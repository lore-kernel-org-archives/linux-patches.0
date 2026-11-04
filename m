Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831863;
	b=vJxZeUlTXYFIvpVhJw0wQAps+I6ttkfcRvn9V7Iva4u6930yKBKclbZYu1YdXclaxfYZ
	 eSR8ntyDcrTtO7CEdt+y1BF7RX7uhdOg+6c+0nHNPfKwf17Bnf1XPMJpZyuBOICWePRD1
	 sG72fc8yB9MWFDEMIeizkgJG1vilRvRmyEEUzLLng70JOv432FMWQqzb5OyYQC5gQvmSa
	 qWr6dEnWTLiVwZB4LD8S3Oa7UxihUF7gx8P0IUBkJLMc8zEC99He9xFawL6uDbeuFdRMT
	 K2+NdaBEHhH1NHpVYlFo/yU7gptNxEoi5BJeuhzT524YMuyNBgN0PfWhKAslwy16xzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kW67u1ID3xuE5Qr7nX9a2aFG/2QG6mvOlu5uxqu1rKw=;
	b=pJoUpZ+ksKiQ1/Q/wckuKIL8VetP0Mkf5OZWm58EcoSHRJsZ9cna3Zxe2/Q+6NNb6zBj
	 kYyMi7QAPVIUVXdnrs/H1oG+dkwcIPyBDZrSMpFixW12idMsqidMPbbesOZhWULpNRAUl
	 ewS14GkNGA5hBU0aRak/qENdvqIkcjPPgm8xnjolIueFSXIrOUVdvBZa5vqcAmv0vLHwb
	 nA4fJmzgGy0ceGCpGkVffx1BmGjgFwWm3Ixwgubb1Bx5RPUMYG8vLy+kBWFhMa1KVEM5E
	 hLMrk75BgsuSRTt8VxM23/4pG++Li2WAnAXJoj5uXruko6wYCjL9Eh9y1gjb+vMms5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRr8Ai1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABFF606A328;
	Wed,  4 Nov 2026 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRr8Ai1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D5F1F000C1;
	Wed,  4 Nov 2026 22:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831863;
	bh=kW67u1ID3xuE5Qr7nX9a2aFG/2QG6mvOlu5uxqu1rKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRr8Ai1uW6tQJYWpESAfNZpAZMIIU9sgAlkeIa+H3LAkJV28gurWKLwgI3rHR9N/I
	 gk/1rho1Oj1WhTHAcisFWM5IKyaZda/2Z2lJOkWKD9p34XP8+hc/+bZRVRCajZ09nl
	 a2BXZK9xgtmA0ndu2KL4p7qG2ra8e66yq/4iay68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0961/1005] HID: roccat: konepure: reject short button reports
Date: Wed,  4 Nov 2026 16:11:34 -0500
Message-ID: <20261104211109.996633782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


