Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064104;
	b=b+QN+vRFqdvXOj+A7XyKyPXPqBzhfP6z1ZSauV8jyuLyiwjUlNWuPU+wGC9gt1yLt1R7
	 gix08zVk/cLjXy4xqrQRl4uiHj6bp43/B7GH1wDRnsMLT3hfe+MS7ooE1V4V9xXP+AxEu
	 o32S8JsObVUnGWtXx35M9JfdRq4yHIx1Q8SDVuWMZbKEZ0OOgovY3W3l0OAajP7UGFy1r
	 15rmfmEqyJe99+E4P11MvbxHx7K1DVnWEOQrrLNghGsyIk6i7h6p1Wb8axwaKQAu8Fh0q
	 BG0BvGnYyuKrFnlX0ppIIDrv8v2CPCJAX1w2JohO8j139n4vyc6WJkrt1cCBnwz98IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRba5VKKIo6VdpgI/UGjz/GBFJau4GnpZWBm3h8ZlsU=;
	b=ttSbTAP/W4VVjeynaq/vioW0VbKbe1boAFqwwEhopi2AaFZsy4Yu/i0OO1vNLefTD159
	 4DRqd76vLsFX+kGRmsjCApP7RTzOKbiJPKeieH6kpfdZHJYSYqblDZkZpZrLevLtyw2BS
	 J9FTZc3N1/Ud56p+UxeRfwIKBFRvmbrkxpNHdo26uWRHA7TvybGXb9CRn0C/T0asCBL5Z
	 hUIqBo/ERKj51F3FyLSHqbLGPcSr6TKCtSr7VrHeOZTaqHLXQODvKhyUYPDuswKOE9eZz
	 HG+brwgvMiQM4+wN+v2PfA7KBP79GpGb01DNX/t6LK+YwsNeZah5le5eklcQCUVtXSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plso4AMY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FCF606B882;
	Sat,  7 Nov 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plso4AMY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D641F0089F;
	Sat,  7 Nov 2026 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064103;
	bh=sRba5VKKIo6VdpgI/UGjz/GBFJau4GnpZWBm3h8ZlsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plso4AMY8AlEwjRhkQqr7K7C+f6jd9M7jIIR3Sn4UVSFGg+o0J6oXt4AtH1G0uPpr
	 J801QcpE7MHQaH/LtuIK+gVqnS69fKGxwnNg8g5hl0NQh7whswe3xMyIPuhPM0iPdL
	 DJhXkLF7uSQ2yC3apkYvtrn7Qk5ZcykVIB6FHmF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0264/1257] media: tw68: balance PCI enable on cleanup
Date: Sat,  7 Nov 2026 08:42:40 -0500
Message-ID: <20261107134946.790591695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit fc02261fdca3ea95e4dcb6b38ab77f0f197c3750 ]

tw68_initdev() leaves the PCI device enabled after a later probe failure
or tw68_finidev(). Use pcim_enable_device() to balance the enable reference
when the driver is detached or probe fails.

The managed disable runs after the managed IRQ has been released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: e15d1c12c587 ("[media] tw68: refactor and cleanup the tw68 driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw68/tw68-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 509d7ddec1505..7abb1bcff55f9 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -228,7 +228,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	/* pci init */
 	dev->pci = pci_dev;
-	if (pci_enable_device(pci_dev)) {
+	if (pcim_enable_device(pci_dev)) {
 		err = -EIO;
 		goto fail1;
 	}
-- 
2.53.0



