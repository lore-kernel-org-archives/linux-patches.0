Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058501;
	b=bRfTqkUXZz4zU3vDG9KwOh3j2juGqK75X3IfoJItDU2rh1aQlmyMQSRcuPW6OB9Z+Bu6
	 yKuiyypxO0uphgibpquUSQeE8QG+VFsw8+nV8d002n/zgCmjE2zoYje4gdxYFPC2eHOF7
	 C5GoOEKj1q4yF5LLKzftbLxhMoBsSaB9Z3toCJzncMFUM397lL6YQQE/s8DcR1StoFAJg
	 Yip7uK+zD8lu9FBc9JqmIxlPD6lW8EdNuSwMpxUKOcDDQM52TFWKWHjPN5wVQphmQyYix
	 cvsoR/mESDFYnC5PrHYj9UIEFR1Ti1Nvlln0B6H4IyiB59t46jv6CUZp0+4kn5u7Z2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5arJD4BiZ+jODZ+OiNr4rv57jQGIW2OEqc2fpDMfmpc=;
	b=vxRkjm+jEdrHvyJ8WFCtJkvylZSv8fmECW2DdaPh6x+D/gvAEOIBQvVuTaF72T6mQRcd
	 SP0ThVPez4YPXJhoS0JY2bnWbTmbPEvvk7Bmc16eU3LJF3FAb1bQaE3NqtpDvTBDEMDWk
	 Go7D8sqCvLVojNCvhSIWJe5k0XbZ1xgCh2FQAUw9lneoJPGBHLLdmT6MQ9jmtqULMoxxI
	 0vFPBf0CMLud8B9c38+qUyDDw+3k5AaD9cwJRdrIyhc1d8QlWtzbwaZPdvDLhv7SZGuV7
	 v7e+wkgQBVHSGPnZucW9YMNQhxLWm2mq7lomLDBLTDrTbWlS3sa4K2YFS5YjzVGaskg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npVBERbn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DDC606A320;
	Thu, 19 Nov 2026 03:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=npVBERbn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1851F000C4;
	Thu, 19 Nov 2026 03:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058501;
	bh=5arJD4BiZ+jODZ+OiNr4rv57jQGIW2OEqc2fpDMfmpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npVBERbneSvhaCn4j1/VT4Zt3Inj5ulQKwBME4Riejz1IrtwZgPsckToP1UKnBXZt
	 vIGkqHBM8pTpn+/8tOZAXBwGPmU/M5ZDQ3kwwV/gkPFoSTJst53Le7+1hjSNc/OYLd
	 ZIWQhxBoUo9B1++mMmMu7RzZEehFMZ6xlpP4fX1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+e5693071d903b832@bugs.sh,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	stable@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0508/1848] speakup: Fix NULL pointer dereference on VT switch + selection
Date: Wed, 18 Nov 2026 15:42:26 +0100
Message-ID: <20261118145936.027807391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit e1301ab8a8411fccc7effe0711fc09939a94953c ]

When selecting/pasting very quickly after VT switch, the tty is not set
yet, leading to a NULL dereference. We can just abort the operation.

Reported-by: co+e5693071d903b832@bugs.sh
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: stable@kernel.org
Tested-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260829164945.2691317-3-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/selection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accessibility/speakup/selection.c b/drivers/accessibility/speakup/selection.c
index 7df7afad5ab42..463a7ef19315e 100644
--- a/drivers/accessibility/speakup/selection.c
+++ b/drivers/accessibility/speakup/selection.c
@@ -61,6 +61,9 @@ static struct speakup_selection_work speakup_sel_work = {
 
 int speakup_set_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	/* we get kref here first in order to avoid a subtle race when
 	 * cancelling selection work. getting kref first establishes the
 	 * invariant that if speakup_sel_work.tty is not NULL when
@@ -120,6 +123,9 @@ static struct speakup_selection_work speakup_paste_work = {
 
 int speakup_paste_selection(struct tty_struct *tty)
 {
+	if (!tty)
+		return -ENODEV;
+
 	tty_kref_get(tty);
 	if (cmpxchg(&speakup_paste_work.tty, NULL, tty)) {
 		tty_kref_put(tty);
-- 
2.53.0



