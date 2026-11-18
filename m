Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035535;
	b=UtToL1pcz7UtovDc0FEfRWo78H6fIeE1V0Xn/glTSDh7QHto7p9vKsUIBV6yGW0ZgtRN
	 dtJz0AGEMmFieAU+xpqVUC2xzwN7d6hBoIRR5vAZICUIqkhJ6HouRM8Sh31fjaGuEYI8c
	 kJck1aGLROz82cBaSwlNpAa6Iea4azO8putf6zpjIhfFHHXJ86q9w9noBoqBRre2C0wAU
	 GfCnoTf8u0VcRVqqo3RHtpqBzsXTbQYSBCs2DCaGn1Pgd2xBU1Lqre+N6d9jyItDP0Vi+
	 k1n/IdHzbWdffgHtgNybB76A5Ralbgu6nAxRT0X6ERfi55KuZs8yow2GxEfPUklg/Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0h0YSS80iPLAncYTTScHYpZ8Hb43Ac8FTbcQ5h4M3bQ=;
	b=2FMZ4Gkk22+tZmma71A0llwaygJ64g1ErjtxiwCRed0y59T3lrGaPIeyW3YUjJX6Pmyj
	 32UbwN1OJXlCKNrAV6R6UDatffLiP9EnpHHq4Zrzjfv4Dca9xMv1Lbfjq4bUuILvfOdkl
	 2L2FojbU1iB7iYFLXH3ICXo9+JicuZmg9NjvU9+gtWvDqX5lQqTv+r93u7TeFouIRx3mL
	 Z2lmi8fHW2okc9IikXsiqzZRUpvpby2e67nJSK8fBPae7mVou10PVQjcAS2BMYWcbrR6A
	 bi/A9USrcMETisSYCa+GaY2HHpvlSHUnhwidhfsdOQzU46CEaYJnra6OOjST+guImdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0oRXx//j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363E606A31C;
	Wed, 18 Nov 2026 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0oRXx//j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068A01F000C4;
	Wed, 18 Nov 2026 20:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035535;
	bh=0h0YSS80iPLAncYTTScHYpZ8Hb43Ac8FTbcQ5h4M3bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0oRXx//jckzmFNqIA5Who+NuhjeSpthw9B19aLN7axeu0EVnlM5eIqUs23icFH96w
	 VRx/VskFmWjiHhuZGlEgQYDzy8YNTOCC/Y/ZppFzW3YPiOsgRxx1E+GQtuv3tmItR4
	 Yq2PdcuvLGsAtjsXvUeHNPtxjFmTg/z6kM+dcG10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0737/3318] HID: roccat: konepure: reject short button reports
Date: Wed, 18 Nov 2026 15:22:39 +0100
Message-ID: <20261118150340.682486606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 1590b7c9bea0abe7a5d25dbfe06287c48c238a6f upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct konepure_mouse_report_button.  A truncated report can therefore
cause an out-of-bounds read and expose adjacent data through the Roccat
character device.

Require a complete button report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 8936aa31cd5f ("HID: roccat: add support for Roccat Kone Pure gaming mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-konepure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -181,6 +181,9 @@ static int konepure_raw_event(struct hid
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
 		return 0;
 
+	if (size < sizeof(struct konepure_mouse_report_button))
+		return 0;
+
 	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
 		return 0;
 


