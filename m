Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212121;
	b=Nhlf2U2IOHf1ag1Yim9aUHJQ4Ra95FZ6veSeTftZ4v72LtzetV9ogvCe1xQhlckhlbp+
	 mnT0o25Pm6+fJfDyge0U1j2migUwZOkbEWMlpBeqLisyNl9CTxFflcwZQGGoHCBV3oYrD
	 OqNp2mwCSKD3tmPP6A8Wb3Oet7QkzGF/EGOcCLJp66pvKi+/+pnWAlCynQ1OSB/yrAzyK
	 Dm44ttcnwM4H2bL2I1YQem7G4WZ5D1XG2YjprRWm7m2yAALIRbAEdz4PkGUVVThzhA53B
	 OlSjRHLF4k+g+Qf8Nt3hSYPktMmiq+zohutiUwagDULYDvJSS0rfAxDpD36lx/jRElw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eeN0osw9VbK2jC3GEl9SaucJqnNyK9CR88KpQgSLUU4=;
	b=RqWtLs6TMwsIoiKFNONo0hN6NHapgJA5t15tkfYj1fAInlHzXdMWbVm9mG/sH0tiFNxQ
	 wI0jn2PqcCldMy2tNwGwAIvCw+PIFn8r/zMseS1UkIxGOHzIgdJm/HFM4qTITvIZ0DuiE
	 T05xiWQCaS3KBRx48CiaAen1N4ODEqQ0eeE665K22hzmUW7S+IJsKs4TlQwVkuEznRfWf
	 y8DTQqH8hYCNK6IV660GmMCQnRdHKuML8dx9dPi4eiH9th8oq8ofUKuEfajwlrLIoEaPS
	 4GxD9KxQ5TApM2I4OwQ8XNm3I/35Thmx/g7344/TjF97efW+pfTzMQ674Q4Kqs1+YFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAdtpzRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C2606A31A;
	Wed, 28 Oct 2026 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAdtpzRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874DB1F01825;
	Wed, 28 Oct 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212121;
	bh=eeN0osw9VbK2jC3GEl9SaucJqnNyK9CR88KpQgSLUU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAdtpzRs3xw1is1lnyr+y7yCGRUXAsQIOSWi6mSTtMW2dv4fhBH61eAvuV2KW9JYw
	 r4EkwzyUHEznmjY6iw3A5C8sKoJ2C2j2QkR2isIf0aHZglD0n0r+igCdTQT3OSS7kZ
	 DV7kOBD/D9+0nMEBdWWludUHv3hIjjP+fH9+ax3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0044/1887] Bluetooth: btqcomsmd: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:35:40 +0100
Message-ID: <20261028170500.228219901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 4a62832f565c950d645a4f7b199a0a7985815940 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: f5a427b16e45 ("Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqcomsmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 11c7e04bf3947..88dbb2f3fabf9 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -197,7 +197,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int btqcomsmd_remove(struct platform_device *pdev)
+static void btqcomsmd_remove(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq = platform_get_drvdata(pdev);
 
@@ -206,8 +206,6 @@ static int btqcomsmd_remove(struct platform_device *pdev)
 
 	rpmsg_destroy_ept(btq->cmd_channel);
 	rpmsg_destroy_ept(btq->acl_channel);
-
-	return 0;
 }
 
 static const struct of_device_id btqcomsmd_of_match[] = {
@@ -218,7 +216,7 @@ MODULE_DEVICE_TABLE(of, btqcomsmd_of_match);
 
 static struct platform_driver btqcomsmd_driver = {
 	.probe = btqcomsmd_probe,
-	.remove = btqcomsmd_remove,
+	.remove_new = btqcomsmd_remove,
 	.driver  = {
 		.name  = "btqcomsmd",
 		.of_match_table = btqcomsmd_of_match,
-- 
2.53.0



