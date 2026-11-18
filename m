Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057969;
	b=uxpzIeXOKxaH2SsuiDHyItN1LEJ0aaHOEF2u1J9IsLmBCbRh1mv94Rq8s+wnQXQ7uIGA
	 NzIj5qNqE9XHZpvgiuR9LdQor/+XocAa4IbSCbVNnNlBVMQR9PRLwqzfCUwWZpLHlH5wH
	 WaA6mxn/cWH4NU4UvVgJ8wHWxZrfzZOgwvQhXUr3yvwKzj1IhcS/Cpmoat3zVpI48tp4B
	 eZuJ70ysKOtJE5SVmglx4L3wqTy27dS9Er9aISS+TsurCfyX0lJmJocAGu3Se/y6d7KXJ
	 eBTIpL4oS99nlDSMHmkKWiIVf2BQ58eN7WpqTZS4WdvfEW0a4i3oUSTOnipanLZsXwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJFh9lk+rRSvvCUKeHq6AP3x4nK73Uq2t6dN24EkBVg=;
	b=unXC7yRDIYZXivJEPW0MCPqQ8QOys8SssbyEgr6/7lXFF6nbH87nxuK6MIPjijTvXHDy
	 H4oJtmF4+h9+OieZr8D4izvFH9UAzhjWKCcVCssGr7B1xR8ES3wvSM1NzgYuM8vXdVLEW
	 E/pgpyIkVWRH4Vf0YC7zCeVgPqeTUHP9PUgzNy/sEocvo69soQjWpn4wDLoxHojfYXuVO
	 zsuBS5GP73XO9a75yvCFRk4ve2f7ThX7QxEa7eEfzDC8+dr5jlENS9VBROJ8v1ixFiBTt
	 we653FceZ/fEpdxrJxeHKCI0EyMRnWNgT6klnYjLLOjSJafiU32uSl0/7/Zk5qm0VFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXNOszXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB420606A320;
	Thu, 19 Nov 2026 03:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXNOszXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABE21F000C4;
	Thu, 19 Nov 2026 03:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057969;
	bh=kJFh9lk+rRSvvCUKeHq6AP3x4nK73Uq2t6dN24EkBVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXNOszXiTQ1AInwtFtmExYbHMq9xbmVCt16qNjqnMXS5W7EXBj7G9uEFakYgEF8Qz
	 zlydRgzEZQctHn51Mc21aMHXg/NjzbOP/Z/6baujAMf8DZDZw8qQEKUNtZ3YiOjQHH
	 iSjRR/bBFu9MOhpI6yCoRrsgLBsm+q+ttgONpovo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0320/1848] HID: roccat: savu: reject short special reports
Date: Wed, 18 Nov 2026 15:39:18 +0100
Message-ID: <20261118145925.578072519@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 76c51fdc825a0486f8d88ff896d39acec8f377b4 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to a helper which inspects data[0] and, for a
special report, reads the complete struct savu_mouse_report_special.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the special report before calling the helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6a2a6390cf09 ("HID: roccat: add support for Roccat Savu")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-savu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -179,6 +179,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


