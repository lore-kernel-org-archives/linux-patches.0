Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD194285045;
	Tue, 17 Jun 2025 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177016; cv=none; b=JKbpSNphVNrGH/c0gznypYPvVpfSjhAUNFnWa9U5ZGXyvfB7ecgJHdDf6go79qd7PkeW/vyH8KNs3+7dwgAQ8zX67Zstw+XqRJNih5tJqkpY6/BiJ5Yyfwv+b+0psm5NtUvrLlhJDSGXOgZy6l/OlJWXO05LyTjUn5m9iWIv1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177016; c=relaxed/simple;
	bh=m+ogHYYWoKCPbQxOQzZRuIB0tJKckvG3fMXBotDXYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIJsMnkgHfqniMAsdDQGyDWxDgcz2ZJhosxT+s40uVuzzaENsv0JFmHD/Rb/7QS+sPEPTf3S7dxMNofL+FqZ9C2zlApOeKRGPRjW87l7RiITUgW62uflNVKOersIRLBx6zD/yPkQWJ1QQ22ZToPH/GCaLLJQ2FrxqRbWbyH1DX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMJz0D6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMJz0D6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE82C4CEE3;
	Tue, 17 Jun 2025 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177016;
	bh=m+ogHYYWoKCPbQxOQzZRuIB0tJKckvG3fMXBotDXYvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMJz0D6LqOSifZhr7D+7SvOcmrBCLG/RsoDbhs6x8inUHkPEj+YvE6sbftoX3YmuN
	 kp1umKwl4flfkiqWQ1c0HhexEeDWozKRm6G8iSJRQyTQHGa0KR0OYQ5vYOcyfBKU68
	 zS0RDj97Eg+OpVQ1VcjNheUeEiRkf4JPlt68jPDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 249/780] clk: test: Forward-declare struct of_phandle_args in kunit/clk.h
Date: Tue, 17 Jun 2025 17:19:17 +0200
Message-ID: <20250617152501.590997599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7a0c1872ee7db25d711ac29a55f36844a7108308 ]

Add a forward-declare of struct of_phandle_args to prevent the compiler
warning:

../include/kunit/clk.h:29:63: warning: ‘struct of_phandle_args’ declared
inside parameter list will not be visible outside of this definition or
declaration
   struct clk_hw *(*get)(struct of_phandle_args *clkspec, void *data),

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250327125214.82598-1-rf@opensource.cirrus.com
Fixes: a82fcb16d977 ("clk: test: Add test managed of_clk_add_hw_provider()")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/clk.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/kunit/clk.h b/include/kunit/clk.h
index 0afae7688157b..f226044cc78d1 100644
--- a/include/kunit/clk.h
+++ b/include/kunit/clk.h
@@ -6,6 +6,7 @@ struct clk;
 struct clk_hw;
 struct device;
 struct device_node;
+struct of_phandle_args;
 struct kunit;
 
 struct clk *
-- 
2.39.5



