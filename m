Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829177;
	b=BnHY7Lo8kWffhrw6R6NflaOEX+B5uoZD3EL+6q2oT9vuif6vY+eR2csjw9KMYqzkBjhk
	 OznWMOekrNwjxDJ2hZHUsi926Yqdcn2uZy8AIH/plnxHxqmnO2Z47GEJlNXNcUuyhCCC8
	 xuaeh0YBi2D+ncNbQjVmM0NZ24HbbBXnTUyhaQsnyH9lhzNW7YvDPMU24RlNmhsO+QK4i
	 3/E8bqi/IbJg7U3X/K4PJz5Idgxi8F5hkqBri6DulcmEHcusYh1CWcqMP0dX4zKPPpKbo
	 6cgDO9mk3iXa14STaQ/8BRYzpDZ735si8+sr6vhnWhhTOuexeP5pHFu0t4wktfvWw1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zkTWgouLLPnDh5S8ROkuJUHL/tNkqCBpF/RpN/CqQWg=;
	b=twd6mxFf+EXGpOH9RGeRFrpsOHTTDjUZltm/r+3GHZEf6iqUQgzV6emXHP1x8+CTrxf7
	 CShYxROnGEpIXLgfpb8cWyzDFITRWc3WVaSStVa/4ABglBmy/fU8/QYoB1WXfeRcLjEEK
	 CnfPqnAJA1r4n3FfJ3HTdgnobUWRW3oI2wv+oI3ZdqMX+Gg1xrDRfCgsNyjE3cTcv9RQU
	 gLyg4DDuK569eLMJGlDOC17Avr2t+ErOtHgCOnH+7eou1dNO6zinvgTTa84DZRxIz62Qc
	 JQtJ6edApa4kqcs4bmmTMN5aKNzvG7UnTBgihAzGW19u90/hLvkY1UROaVleNqwMUeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf6Db2fv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C8C606D806;
	Wed,  4 Nov 2026 21:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zf6Db2fv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B12F1F000C1;
	Wed,  4 Nov 2026 21:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829176;
	bh=zkTWgouLLPnDh5S8ROkuJUHL/tNkqCBpF/RpN/CqQWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zf6Db2fvWT/2OtB6IckV1uId7HezakSIJpTcOzmFqus4NvnPb+gMU5LcL6iJegW+E
	 VraLuGm5sC2xSOyww0r+UTg7gcrShvMxRI/e7NLr7Ske4EyCx6Lgmi3rqd6VvoYEhw
	 9aZC7/6U0r0T3+X5oSV3fke1J1Gzi/IBXgzhsaP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 494/547] HID: mcp2221: always initialize and cancel init_work
Date: Wed,  4 Nov 2026 16:11:18 -0500
Message-ID: <20261104211052.408239093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 6a006ff898b459e0bd10375d7fbe0ea7f7a132b9 upstream.

The writable gpio_mode_enforce parameter can change between probe and
remove.

If it changes from false to true after probe, remove skips cancellation
of init_work. Pending or running work can then access devm-managed
driver state after teardown. Changing it from true to false can make
remove cancel an uninitialized delayed work item.

Initialize init_work whenever IIO is reachable and cancel it
unconditionally on remove. Keep the parameter check only for scheduling
the initialization.

The false-to-true cancellation gap was previously reported by Sashiko.
We also encountered this issue during our static-analysis research.

Fixes: 200e6c6e94fa ("HID: mcp2221: Add module parameter to enfoce GPIO mode")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/linux-input/20260715143415.916A21F00A3A@smtp.kernel.org/
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index db0b15622c39..053377dbced2 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -1072,8 +1072,7 @@ static void mcp2221_remove(struct hid_device *hdev)
 #if IS_REACHABLE(CONFIG_IIO)
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
-	if (!gpio_mode_enforce)
-		cancel_delayed_work_sync(&mcp->init_work);
+	cancel_delayed_work_sync(&mcp->init_work);
 #endif
 }
 
@@ -1347,10 +1346,9 @@ static int mcp2221_probe(struct hid_device *hdev,
 #endif
 
 #if IS_REACHABLE(CONFIG_IIO)
-	if (!gpio_mode_enforce) {
-		INIT_DELAYED_WORK(&mcp->init_work, mcp_init_work);
+	INIT_DELAYED_WORK(&mcp->init_work, mcp_init_work);
+	if (!gpio_mode_enforce)
 		schedule_delayed_work(&mcp->init_work, msecs_to_jiffies(100));
-	}
 #endif
 
 	return 0;
-- 
2.56.0



