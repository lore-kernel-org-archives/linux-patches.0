Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F948645;
	Fri, 15 Nov 2024 06:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652769; cv=none; b=O65tdfFhsuc19c5QrvU2W/Spay2PwlrBMIn7m3ZiEulVG/QNXkhhvA5JdEpsBXndsMeFjpNA1Jsg3CYEUJ3BnQxn8o/haTVJR/X/jUFP/GSFBqYxsoayvPbiSsBY0IWl8O6UAH0JZXMXg+xT8Nl4YT8R+2FeF+JTUuOEeNfQ31M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652769; c=relaxed/simple;
	bh=5Us++We5IL7tiF26uaglKttiSPV2gHFAa47tPfYSFHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfVBB0w0cUXV1/afxaziSBWWO1cNA3sZCp/Rbxo5zEAF1Bd7JzzmB4tEZm8QyOPo51ls9/LOUNJ+boX+3wl8yCKRPNoja7dYAATLE8kKJSaa4vnrPBi76GkUatcBmFJvkB2izaj7/2YzIrXTdWbZ2xQBDjmGzFw6ax6sle05o7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/CxzI+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/CxzI+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E39C4CECF;
	Fri, 15 Nov 2024 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652768;
	bh=5Us++We5IL7tiF26uaglKttiSPV2gHFAa47tPfYSFHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/CxzI+tktc05cALWS4yYEqPLGUBn1Xcfk/Xzgmv4GttkhQQNRT6ygYVpDwdZyDYp
	 pW3oL/ksZ/ZDI6clBn+pw5fh1M0uOUNoXr+2SJLgMO5Hiajq/4Sfi67wEApWru5Ahi
	 Oo1OjMxNTAJgx4HYMcLAPQ6hyHjMw0Sgx5GAA9rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 10/52] media: stb0899_algo: initialize cfr before using it
Date: Fri, 15 Nov 2024 07:37:23 +0100
Message-ID: <20241115063723.226386229@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 2d861977e7314f00bf27d0db17c11ff5e85e609a upstream.

The loop at stb0899_search_carrier() starts with a random
value for cfr, as reported by Coverity.

Initialize it to zero, just like stb0899_dvbs_algo() to ensure
that carrier search won't bail out.

Fixes: 8bd135bab91f ("V4L/DVB (9375): Add STB0899 support")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stb0899_algo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -281,7 +281,7 @@ static enum stb0899_status stb0899_searc
 
 	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
 	int index = 0;
-	u8 cfr[2];
+	u8 cfr[2] = {0};
 	u8 reg;
 
 	internal->status = NOCARRIER;


