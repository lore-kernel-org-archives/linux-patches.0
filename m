Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061806;
	b=hWMTOe12U/HUrKpqc5YDhkL5nlrlUY//O4u6+o6OGGWQTKETtDJqaxEursFsbbSdaWBY
	 wQS9MTz/wB4OG4y/4FUwqgZLDj+1qiiDmXH+/ns46pQdybr8l6H/urc/dL+eOvvkx3BkQ
	 ZJ8bPfz36f8QPSIv03V5D/x5cM5SLxmbqtEGRdM5snSw7llX/KdAEpuS2S3aGfXIMiEGk
	 23BU62UAkls1WEz0ArVXOt+xv5bnyK0FBZH+fdKztMLrx24G2yu25hXI0MVXxNNSQM0/N
	 nRKPjvwGqgdWMwrpHjY+k/T0Io7RwWHwa0Grq9NcYhb+GhOoUpWJC9dJkpAKRPTFaUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6Oqn0hlMMbwr3Aq31xblxVrC68gx4JIK5mdPs4WAow=;
	b=mK7hbsN4KevLy769Enti1XVzBK5JAkrdSlMdB4JhAk+melstUpr6fyUeeRDETYXBHoRO
	 4hA+4H2BnUFBdmNTdcHyj4/eI8KQlm5smr/xWQrtmReevzLWD8Spgbc06EFUuUk/fH6/n
	 Va5ObkOPDYpNW1PTNDB+T1J8+jxISSoLwgHoxZ9pUracMDeVj6faVuFiH0ZX+VuHAAEmY
	 bK/QRLiZOlmrTEHpYDu/5p2JWZI1s5D+8fKI1jjQcrWw+VnELatFJiLcwZugxtetv9sXc
	 hlPvg0MwREq3aTNWipyKnvnNlZPf7bzpKa3rSII1ICrFbWLWkrya3cRAy7ZzUeZHSFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfiHus4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7737606A333;
	Sat,  7 Nov 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfiHus4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D6A1F0089F;
	Sat,  7 Nov 2026 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061805;
	bh=+6Oqn0hlMMbwr3Aq31xblxVrC68gx4JIK5mdPs4WAow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfiHus4md8iI6Au3aGTGdhumOsDJkXRAMQjkQLZ6aBQMvTVkpY6RzUrtwvf0i6wyj
	 XfI54Cn89auDUA3ORk6/wfUJDwwyvNDIwNQowGREU33x+1ypE8kKFKXoC8zrEcEQmL
	 vm5saS/zLYu1FxkNHg6wjikAY2RZrDZ0l6oEvjOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0825/1536] HID: roccat: ryos: reject short special reports
Date: Sat,  7 Nov 2026 08:47:21 -0500
Message-ID: <20261107135020.715998333@linuxfoundation.org>
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

commit 02f3607d0beb82e76481568bf631235e6a319b47 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct ryos_report_special.  A truncated report can therefore cause an
out-of-bounds read and expose adjacent data through the Roccat character
device.

Require a complete special report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6f3a19360545 ("HID: roccat: add support for Ryos MK keyboards")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-ryos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -189,6 +189,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


