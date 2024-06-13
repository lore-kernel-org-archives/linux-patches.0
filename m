Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA711C32;
	Thu, 13 Jun 2024 12:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282920; cv=none; b=gMF3EHf4z0tW9wO7woRqh3c4H/TdaYeHyjPNTdRj7On0AcDOgNG8bKx5lwKjjAFGABdS0csg6s5YsKbRMeZyRK+A/PsLnLt8bCfP61MF88aEm40xR3YAfLzQ6NnvsRnbOFv8Lw+hbQy2fiNTWcPnXhA/JMHolzjjuQf6Fi2G7jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282920; c=relaxed/simple;
	bh=kfnYECqkozsAQjHem5xSAkvFCb8hYjqrvjd8axuLc9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjFU696Kke1L25fFXYRBnLuExbEWfif7T7BpiRLJtgpFQQY7ZrYED9PDKXHdRs6nDEIBlU7CAhGGxRIYjWdGvqhVUpbHNUd019T4c0LTOutWQ8VaWstIaD5zA6a9M1J3djxNDY4smyCbV1VLLKWASlOg504k8MQX9bTI+4w5UpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiD7svLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiD7svLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647A9C2BBFC;
	Thu, 13 Jun 2024 12:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282919;
	bh=kfnYECqkozsAQjHem5xSAkvFCb8hYjqrvjd8axuLc9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiD7svLTxe2AxYOPqbi1qQTLwGs5u8c4M6AmI2KaIKJ4NeDKSdWq5G8f7+GLak2xS
	 IMpmwYEZ8BQArbnK1thommNcs9Mg/CP3yowZDC9blfzViqK5TX12+QivDnIqxSa3/t
	 Tp3NKTDxcZXFykTyANejA8kkWAAEyVQZug+hgwoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.1 20/85] wifi: rtw89: correct aSIFSTime for 6GHz band
Date: Thu, 13 Jun 2024 13:35:18 +0200
Message-ID: <20240613113214.923003617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit f506e3ee547669cd96842e03c8a772aa7df721fa upstream.

aSIFSTime is 10us for 2GHz band and 16us for 5GHz and 6GHz bands.
Originally, it doesn't consider 6GHz band and use wrong value, so correct
it accordingly.

Cc: stable@vger.kernel.org
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240430020515.8399-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -263,7 +263,7 @@ static u8 rtw89_aifsn_to_aifs(struct rtw
 	u8 sifs;
 
 	slot_time = vif->bss_conf.use_short_slot ? 9 : 20;
-	sifs = chan->band_type == RTW89_BAND_5G ? 16 : 10;
+	sifs = chan->band_type == RTW89_BAND_2G ? 10 : 16;
 
 	return aifsn * slot_time + sifs;
 }


