Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051921;
	b=y1XTgMvPbkf+Qm1ieVUGHoWjzkvM3PBef9RlqM1DZcQsfz4vgKWIPQo9SmX8pdagNATk
	 jMomBK6BA8un9pmR/DKQoFINO7hh/iftTyRFejaSD/0b7u5MuQxOrOvmIN/EI5W8jeOWH
	 5WvjcJt5VJ2b9W1Rn6QmhtoasbmnjznRDkKgiRIOTBGqvTv3GnGk/GPQMDF1uMqv8DEzB
	 jc2fcwT8ureHsjYpFAFFmjeQh3S6W+Nk1kcOEV0cyMu/2Zw0+HQ8uOu/99pwHtVEpcZ1T
	 sFiqqkXrQzGHQ7fX+r+DZdk4PczfvlyVQx004WQrvJ5q7GzeQuvuzKvphE+kMW/E7dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ATgvnMesj6JMyCgBMZITPJCl262fokm1S1Pe+DwvRFY=;
	b=soQAqiuLIvV/3LHCjgoJNNLaydUmFQv6bE7WJzuhkOEYt8rfpzEpkcMXYABFtVazJQil
	 rUYBnMYtC7T4bljrZvrLfvLFjmC/erNdvu6WdWSnl09RKZh8qVLtCYRaBMoGe0EspejwJ
	 X7Y8LF732JcH753AmfRyiceEstVxNnpWMMzp25GDSIFKuiLVUNaw7DOlmsFek7P4/ePPo
	 /nZ39Z/7QUK+YgFBcazXRUpYTeO7ZgBqXM/s8TUaJRMEFv4GP0XtJbQyU+sS69MQp++IB
	 WIP6xuCzZznQvRgzSXjCNdyb+MzYbm/9i8n4pKolUODgvQWeVZSM2qQYFBf04yeyFiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9ruhG7R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EC4606A33A;
	Thu, 19 Nov 2026 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G9ruhG7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107EE1F000C4;
	Thu, 19 Nov 2026 01:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051921;
	bh=ATgvnMesj6JMyCgBMZITPJCl262fokm1S1Pe+DwvRFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9ruhG7RFVSQ2+2l86Zg49hh237fS4QF/PdmgdC26fgwKxtniVs2aNL2cJk6kNiPk
	 FJuczdvvchWV04rT2Z1ZltOaZpEXRzLqWkHlrwMqaBCCQ1/1RiDOBkAN68pFg5rInc
	 dNdXVp/9Gvh/M74e2qmasNx5cITrJqPiorPrJzto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 0381/2214] HID: roccat: koneplus: reject short button reports
Date: Wed, 18 Nov 2026 15:34:17 +0100
Message-ID: <20261118150025.942282134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit d879e17a8b4c572c0b53b4e42a36849484e8f00c upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct koneplus_mouse_report_button.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 47dbdbffe15b ("HID: roccat: Add support for Roccat Kone[+] v2")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -520,6 +520,9 @@ static int koneplus_raw_event(struct hid
 	if (koneplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct koneplus_mouse_report_button))
+		return 0;
+
 	koneplus_keep_values_up_to_date(koneplus, data);
 
 	if (koneplus->roccat_claimed)


