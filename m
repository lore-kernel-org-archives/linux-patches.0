Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624305;
	b=z4fbN/eHTOlXcHiPU6119fFrJUtqqo+ozgMJ+KD8v0sbEKExyYxT0doNAVQJAXF+tvv1
	 X5XNu/fuzmQC5ghmob9YbkZuGNIhYAZmuhfltailXf7aDFzUUqM+oIEMPq5Pjm5Gfu+lR
	 Z/7z2iE7j744h2jGNpiMkgghtSQWqJcVuin8OZJu0mtjgZ1PmAAf+DImckYeQNppcb+HF
	 +ZxYHD1Rc8YFVXM20tCvMY7CraUqMgNj9QjA1OoA11MxXH+VNtRFNccwFoU6Q53ZcGRS4
	 WtOCNeSneVxF6N4YZeUTVepJko6EL7aldeoMH7S3NrzSiBvbUvnGqRmQMFhDaQRRROA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yufCwbTjrW94ScIYQY04bLoOuZ6/sEZxWY/NvbtHSew=;
	b=smUA/xpRMg3RqFTobuo2yCXgVOHY13NrJxVRBUCtDG/lYgZt8WQPv/fsPxswsQmgh21A
	 jwP7T04vYW1WWMmQ9eTPeLDbx/X8SOYW+VFmGY2jgQ9K1aXWpj0FcchJYgeH8ig5pqYlS
	 IwhsKCm+q3rZc/PTGZOmx5TqV+6yh+2IlM0wpdxfM4exi7J6lssmJ1s7+FSjMulmTF+Eo
	 vWIFtQwqQnGlFxXDWcrFFkbguge8z3mo5ZQIcwNvK5itxNz/FTB7NX7ms8+4a46kT2yTd
	 q2rnqOPaNma2F31Yp2HYCppLrjbAKTLkZohBLMsIqnQB+j+wvVNnFC5wNOzbiPW8odw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lERRK/Df";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52554606A33C;
	Wed, 25 Nov 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lERRK/Df
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FC81F000C0;
	Wed, 25 Nov 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624305;
	bh=yufCwbTjrW94ScIYQY04bLoOuZ6/sEZxWY/NvbtHSew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lERRK/DfBMZ8EBOO7ujFV0h3nFqhnJMP94mgbaym199Ha1GrHEu21vToB5K1zD0oW
	 M5UV6fHTY0ELjqoMzDND6VJo8kcLubaidsTS6NHnVQVRmxgkcY0gOKxghbzom1q69j
	 9PhE73aFX4L18z+3h2MTmrewSe9rg9c8VG6IsLq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/816] Bluetooth: hci_core: Initialize LTK before publication
Date: Wed, 25 Nov 2026 15:28:18 +0100
Message-ID: <20261125143852.669270924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 4335849380aa1081ee9a1c2b934cbdda0961fa57 ]

hci_add_ltk() publishes a newly allocated LTK on hdev->long_term_keys
before initializing its address, type, value, authentication state,
encryption size, EDIV, and random value.  hci_find_ltk() and the debugfs
long_term_keys_show() traverse this list under RCU and can therefore see
a zero or partially initialized key before those stores complete.

The race is reachable by racing an LTK addition with another CPU looking
up or dumping long-term keys.  For example, userspace can issue
MGMT_OP_LOAD_LONG_TERM_KEYS while another process reads the corresponding
debugfs file.

Initialize all fields of a new LTK before list_add_rcu() makes it visible
to RCU readers.  Existing LTKs remain published and continue to be updated
in place.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 970d0f1b2803 ("Bluetooth: Convert LTK list to RCU")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ddd0bbaf247e0..c7529bcc9f0e0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1337,7 +1337,6 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->long_term_keys);
 	}
 
 	bacpy(&key->bdaddr, bdaddr);
@@ -1349,6 +1348,9 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	key->enc_size = enc_size;
 	key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->long_term_keys);
+
 	return key;
 }
 
-- 
2.53.0



