Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5B4D583;
	Mon,  1 Apr 2024 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986748; cv=none; b=VtTQb16PZ8pWbysQwmujvwaYfMmeJsdkib7+fBGdgkxQnkrg0D60qYqr4g6ayySRYLSkc9i/HJFpe6bZ7hq1mxK/rFxun0NEaCvZiEbYsGYpDXTLmmjUnNA/3xGc9OAwJpn/wMS3UtruApu+oR6TTWeRs4dISMCT3nuFTdqRcCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986748; c=relaxed/simple;
	bh=QqvJaQc1Ne3l/KWNKTPMdWMg6sqsdM9I6ycy4/dA7R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nipo+Me4QsEgR5YlpoUtsCsw/LwExHQR3nVniohW0c5lf5xhEQumnOdVUFeoATgfeg99Fb/r9scXWNg63YeSIOX/GqKM+2B6rgv/b2mAC+aVP1rWkXGiJRIrtPd3ZLq2XdWSJbLqIGpcp9wTpQNvxXWwkAsWtpBB5D+iqfu3rYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDxczOJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDxczOJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA9AC433C7;
	Mon,  1 Apr 2024 15:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986748;
	bh=QqvJaQc1Ne3l/KWNKTPMdWMg6sqsdM9I6ycy4/dA7R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDxczOJQta/hti0EPrkhCAiSENEI3fzod+Kb/Q853L7q5EJZdq6msIAVF46ZSRIhc
	 Kx4FUyveuJuZUAPL5Iwd2ZtFlL30I0ErRnapI2ZbLKedMOhgPWYfjA7oDXliNM4+NP
	 0qMrglTbswUYSZ0/tn043Hrdoxuv1DBLaZVoVvFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 032/399] powercap: intel_rapl_tpmi: Fix a register bug
Date: Mon,  1 Apr 2024 17:39:58 +0200
Message-ID: <20240401152550.123683768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit faa9130ce716b286d786d59032bacfd9052c2094 ]

Add the missing Domain Info register. This also fixes the bogus
definition of the Interrupt register.

Neither of these two registers was used previously.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 891c90fefd8b7..f1c734ac3c349 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -40,6 +40,7 @@ enum tpmi_rapl_register {
 	TPMI_RAPL_REG_ENERGY_STATUS,
 	TPMI_RAPL_REG_PERF_STATUS,
 	TPMI_RAPL_REG_POWER_INFO,
+	TPMI_RAPL_REG_DOMAIN_INFO,
 	TPMI_RAPL_REG_INTERRUPT,
 	TPMI_RAPL_REG_MAX = 15,
 };
-- 
2.43.0



