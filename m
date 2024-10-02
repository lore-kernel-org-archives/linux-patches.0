Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B01D0798;
	Wed,  2 Oct 2024 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880694; cv=none; b=LloQ4yNHMqd0phkt7WrzGkQEhxjg9p9uduTFlbpluJpSEb2WSnZgqJF25TWhvq0hxRKr9zwLraUxehXQkM4xi9Qq2g5RZihvDxx3Z8JhHypEoEfW1nEyQog56NPTr0DR06l/whY7b7rV8P60XTuT4RxCYW05inEUmZuR36oqAR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880694; c=relaxed/simple;
	bh=betsIHgmaRoYKcqJtdny2fx9FQpAYdev0KXdTVxcHtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpTPLUIyPNBZl/lmAPFRDpcLqFAq2CQhuJWhUENmP72+R3Zik/x6dNqrgJbysDsYIxtusAIBY697xD48rVCp3Njbku+JWHf1UVltrP7Tj1IIYFXO3//wV7PojGg+2X+4jksMFg82WCL5wNzZH7RWw0Tc0V3oLTdr2Z4UqEzmFSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTM/t47o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTM/t47o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF5C4CEE5;
	Wed,  2 Oct 2024 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880694;
	bh=betsIHgmaRoYKcqJtdny2fx9FQpAYdev0KXdTVxcHtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTM/t47o/PvJiZSy7Zk2xSApF6f9qk0RomUuCLq3MdMZ+8ESWnQgCBXZXNi2eodgk
	 ZZz1AKgrtDqpcv+ob51UDEKdKGkv6UmWIIf0oKfOxD0VWvnSTDLQXegPdy/x4acFYW
	 ojDSPKw0Y7dtcp230C/Ub9/OC9wd0rCjotVzyZPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.6 533/538] wifi: brcmfmac: add linefeed at end of file
Date: Wed,  2 Oct 2024 15:02:52 +0200
Message-ID: <20241002125813.483216731@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Arend van Spriel <arend.vanspriel@broadcom.com>

commit 26f0dc8a705ae182eaa126cef0a9870d1a87a5ac upstream.

The following sparse warning was reported:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c:432:49:
  warning: no newline at end of file

Fixes: 31343230abb1 ("wifi: brcmfmac: export firmware interface functions")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/all/20240125165128.7e43a1f3@kernel.org/
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240128093057.164791-2-arend.vanspriel@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -429,4 +429,4 @@ s32 brcmf_fil_xtlv_data_get(struct brcmf
 	mutex_unlock(&drvr->proto_block);
 	return err;
 }
-BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_xtlv_data_get);
\ No newline at end of file
+BRCMF_EXPORT_SYMBOL_GPL(brcmf_fil_xtlv_data_get);


