Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5BE2CA9;
	Tue, 12 Aug 2025 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025048; cv=none; b=il7WJx1T1/nN0y/Ijot1mdpUm28tY10h94V3fAei2d44ss98b4uBT5RQbYKjpA/GDO9qh0CC3kY3fSHkIubsA1BYkzYNCZVy/Oa95VFRz9dL2cTKIXS3iFEQc6abDOxBqCowF5nEPcHGZOKSnnRqJHlE0WS+ZzZZiOAo+ZBSYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025048; c=relaxed/simple;
	bh=kFBYCLJ4nsrAr6czstJj7N0POiGsUbkavERGNGU5E2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuzQTtXnhGJnWTAGsM40cIqkVCKyy1VponVXqaWMkcYUVIvtBcwaAcLc/PWn+xA7/llC6YBOUePwFRhlUParbQHR0AKdBX70OmlYRQ+xG7jKpO7dmli9xoYvHOSU7nGCtGKFdC2n1KzyDKEuK+DDBmsKkUqY7qAaPAFR+TOL0jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOmG+SPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOmG+SPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5493C4CEF0;
	Tue, 12 Aug 2025 18:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025047;
	bh=kFBYCLJ4nsrAr6czstJj7N0POiGsUbkavERGNGU5E2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOmG+SPGBo8MYwrWqTcnXP/yejsHw/7cZeNHY6Qlqse00fkFWXQI/XA/vyhgwWPX2
	 JyAJ18Y8KGC4toAM50Qow1miYTFX1Jvf7LZp9oSfrmJ1MAWPYS4jr/OT30PbpHNgr8
	 4L5dUQqrlHsz6xVr5FpN8txP5UpRq5ngFGTS0xJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 527/627] ASoC: tas2781: Fix the wrong step for TLV on tas2781
Date: Tue, 12 Aug 2025 19:33:42 +0200
Message-ID: <20250812173451.953554163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 9843cf7b6fd6f938c16fde51e86dd0e3ddbefb12 ]

The step for TLV on tas2781, should be 50 (-0.5dB).

Fixes: 678f38eba1f2 ("ASoC: tas2781: Add Header file for tas2781 driver")
Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20250801021618.64627-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781-tlv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/tas2781-tlv.h b/include/sound/tas2781-tlv.h
index d87263e43fdb..ef9b9f19d212 100644
--- a/include/sound/tas2781-tlv.h
+++ b/include/sound/tas2781-tlv.h
@@ -15,7 +15,7 @@
 #ifndef __TAS2781_TLV_H__
 #define __TAS2781_TLV_H__
 
-static const __maybe_unused DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 100, 0);
+static const __maybe_unused DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 50, 0);
 static const __maybe_unused DECLARE_TLV_DB_SCALE(amp_vol_tlv, 1100, 50, 0);
 
 #endif
-- 
2.39.5



