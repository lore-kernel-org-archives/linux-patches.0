Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061854;
	b=b8mGiegcaPzrDFxtbssP+bjcKHwORW3ZIrhBJn/uwJCdTQ4jBztHudQfSF5Knq+2B8DR
	 0N9X6K8J8rTPKOsRYbI5RPNClgXwCDihaN+FrdOCd6zkOmryozO4eTH7v/phpr34hc7oE
	 3zFKO1tSNBh5Mf6pvgGHDoDl889m2SaYDoHkE6PbN+hMrD639+r8BNZxBhdmOd2pkv5gl
	 L0BogV7TcJEbUzIPolR2OfLYQzpsOfnBLGkh35Mlt+jFl5+pxUos+BrD/ud8F9a00shDo
	 9+MlFiAK7yrMfWAY1R2lFVic1U0m1QEUaZ3PZdgJfW0UUS5DBrwmm31wXOWEQWm+LRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MDPFGmEA2koU7FKGd+LoCddRCMWhoRJ2B+eyFoMUpPo=;
	b=3dm8xB+gBtReu6lKfMX+4o4PsGYE1WMlTaxLLK/lTxCcytNMvsJyqul2/QecWD6/sv1e
	 no+297tASv4VrMZggwny2gIER+KrWZveH8CRQwtnPXRIyJ9T1fV9HdVrr2vjgtV/YVBP7
	 Agq4MSRhhvxaA122PTnjbMEPnoDTKYSGdG4evLhklwTgMvk1mTqawK0aTTDCNOpWhlD3c
	 bfO6/5vWcdleSRER4NGqCKXJzmW/thu7e4mQBiHKTyQNwPwzvFFDem5h8k+imYZxZdfP6
	 JgiXzEpA8cq0LDobkckOi3/PZLf4sevacD1lp5NVgCdyHhY6ltROP279LT5OoFSFTNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBn16HXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8755606A326;
	Sat,  7 Nov 2026 14:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBn16HXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A0C1F0089F;
	Sat,  7 Nov 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061853;
	bh=MDPFGmEA2koU7FKGd+LoCddRCMWhoRJ2B+eyFoMUpPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBn16HXDPwl7VWy30Y9AAJJ9ICzX3c0jHjqdCQo8UcZnB7TW/c1KusSaqzjhEMLCs
	 MuW9P9TcKgh0mDIQTBCNxAcaPWBw3NrZ+oQ8+imdlvqt5Oq+Us1/5ciY5w1TnrhRGJ
	 +be2KqmpWzYvFTkDbhtM5i7x6FNjo8D8LcLsxxMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0824/1536] HID: roccat: pyra: reject short button reports
Date: Sat,  7 Nov 2026 08:47:20 -0500
Message-ID: <20261107135020.684133766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -557,6 +557,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


