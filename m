Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A724B34;
	Mon, 14 Oct 2024 14:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916659; cv=none; b=PNDbahZ/UfQ1hR7GBO1G7mtiF+9uX91Jc6a2x5BTgN0cgUgB4j0u7wLyMWS1V3pFBmkSqv5XcsWMMXTaInuz2Da0+BY5MYr5KmxMB/5NnDvNLESyocVprsRkXpFFZJmvIpGsXn4VIwQ9ZOjb/tVauRXZkOlRj+V6bvZ6qJfuYoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916659; c=relaxed/simple;
	bh=YniJeMKd2vR2Ay74XM7kSI0XmeCRWEfdLPWqNvtVYfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9l/OP3MrjBmoLjHKAS+ejCRfAe2IRT7WSfq1TnA3Bohl16nFJFWo892W6gP/rahp6k8yBhIfOCcZR0cZcjFiIcmZ9cLs3tYO5lAvhZSBq+aTAh/hjEbW5UvfeGAprOmTbfVI6bmFd4v+dT/pJ23QIfnEeIGa/fRCSdDY15ZUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEQ3KZy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEQ3KZy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC29FC4CEC3;
	Mon, 14 Oct 2024 14:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916659;
	bh=YniJeMKd2vR2Ay74XM7kSI0XmeCRWEfdLPWqNvtVYfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEQ3KZy2oWimtHKM1ZCnte7K27M04FZSyqDbBr07N6SDKkxoIyt4OiOGaDK2PRbR0
	 pM+m4tA2kCWeasm7FI57O25ALlhAZhavfjfaqmtgE+2q4+wXhOMbXlcw/pNoLdiYmt
	 BTMd3fRsPwJfmwlSrnWtNEGtGwxex6gtoiKrwSsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/213] ASoC: tas2781: mark dvc_tlv with __maybe_unused
Date: Mon, 14 Oct 2024 16:18:55 +0200
Message-ID: <20241014141044.123461949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 831ec5e3538e989c7995137b5c5c661991a09504 ]

Since we put dvc_tlv static variable to a header file it's copied to
each module that includes the header. But not all of them are actually
used it.

Fix this W=1 build warning:

include/sound/tas2781-tlv.h:18:35: warning: 'dvc_tlv' defined but not
used [-Wunused-const-variable=]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403290354.v0StnRpc-lkp@intel.com/
Fixes: ae065d0ce9e3 ("ALSA: hda/tas2781: remove digital gain kcontrol")
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Message-ID: <0e461545a2a6e9b6152985143e50526322e5f76b.1711665731.git.soyer@irl.hu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781-tlv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/tas2781-tlv.h b/include/sound/tas2781-tlv.h
index 4038dd421150a..1dc59005d241f 100644
--- a/include/sound/tas2781-tlv.h
+++ b/include/sound/tas2781-tlv.h
@@ -15,7 +15,7 @@
 #ifndef __TAS2781_TLV_H__
 #define __TAS2781_TLV_H__
 
-static const DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 100, 0);
+static const __maybe_unused DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 100, 0);
 static const DECLARE_TLV_DB_SCALE(amp_vol_tlv, 1100, 50, 0);
 
 #endif
-- 
2.43.0



