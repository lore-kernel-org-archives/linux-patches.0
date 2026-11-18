Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044653;
	b=LFHcd7f74IOWUWgoG/K5t2YCRF3lyAxnlQuRy+d07VxwRmKOC9chVStfEVLYg0lP6etA
	 B4QyyBVQI/9i9+lSsOF2aYB+xNXqMdtqHKPD4lZBDcAsVprzq1VCn50jzfGq7YegSW5g1
	 hYEWIZ0Och7ZQ++DRobRgcF+qREb0GzwrZ92AcOfoX4uB4pe6DfsDoWmQialqaZCm4H/G
	 7FSlI21e7z9SQcHOePgAfR3FgnXoEAkhk7axt4nR3PH9xMWkzIYjgI0WLqd4OCr8Z1hrP
	 kGKUPEO1k2vDAamTbCQ32pCBqVpxFGIgJgBmRRe8iJvH0afR97JuNIe2xV7EpartbgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4S9FU8moeACcE+lhG2gZDIU2naxBVYzDkxOU9GmeXM=;
	b=HNgcex7SWzAlvwVxm85mmh0ULwx+iNXnGMp1YR6Af37dPmCsxyRPU3Xb8IWXe9FxL8OH
	 kjcAt49aQSR0T39EN/2wAITYbU3cHbPVZpyiSWeeliMinTIDXylAwP8SEaZ7GgXQTTxCx
	 Pf7kI1JusPU0hELPJQhxLzFRUNTofOM1kPASEgPY+JYKb91Ksjh9Og328RgvcjDQscNHV
	 a0IbudOL3B7vOCW3aWBIj6V3yarwexzylgjtj2qYKHaeeh57Sf55HJsYtTBnrMDjuyJuW
	 vi9IsS2l/WXHe7eIgp6OtLowHZdpkU7qp/y3ULUR/BdkSkLgC4Eeak+RjmIR2Ne3Zig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukvz0vNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81175606A333;
	Wed, 18 Nov 2026 23:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukvz0vNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95771F000C4;
	Wed, 18 Nov 2026 23:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044653;
	bh=L4S9FU8moeACcE+lhG2gZDIU2naxBVYzDkxOU9GmeXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukvz0vNND4hG2K11taRT4C50Bjz/wJoYS3OeF2WoB2O4pcqCfzuDgoR3QMPe0N6bJ
	 hxNw/QQwtC/P0rvtAEeu9NYF0iRGjb5K4S1oMvJRiC2yljR4dRlgqbEsGt0m8P9pf1
	 msey4BFr1VC4OtLl2NMOnyDxmkglPWbjfcplZgrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0644/2857] HID: roccat: konepure: reject short button reports
Date: Wed, 18 Nov 2026 15:27:58 +0100
Message-ID: <20261118150224.716877710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -178,6 +178,9 @@ static int konepure_raw_event(struct hid
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
 		return 0;
 
+	if (size < sizeof(struct konepure_mouse_report_button))
+		return 0;
+
 	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
 		return 0;
 


