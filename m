Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208565;
	b=LQPtQsHN+tNxCquCnNSkycGPy8Vda/LqI/p3Rik7cRcYi7mGj1SJMcMwsobPsdwlIPpf
	 pN3ymG7zd9LXEVtDnHGDsWCIuC/KZx9WGDe65X2WQFWzt7/UcZg6IKX3lk1QDxBh21nd8
	 vK7atOGv8dRBngWq4oGHx7R5PsSlpdu8Ms8xGLJlNxZlUD98xn/GP683ZHjmUey9etrHi
	 BdzRmGIk6vhDGjxP2s9avYh8K78yA4lROIimNaukcV0UIu6umoXQB9kk/PFjI879O+0nT
	 5IwxCGu6Bmizh4jADAEK4OCorzqzeoPaip7Q9BVZtm9EtAocYQs1giFkCAggKvpILgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aA/Ay5VrT62EYQFEd5ayl30FU3z3SqZNkqKGjcGx0io=;
	b=A2IXPEzBRS2OkYnfuRp95APJzsyJ2C1kGwipVMGX4c6iqEGLdoG1imABcMxqNBvsRzmT
	 j0BBGTUbCXuveBtUePEINZGcqQESx1g/xCMGYvIcC8moQPuyr5tCKIbcJF9PeoPkP+udN
	 uufuXVm5hurR8N1OYGA+/IIqeBWiZA55/ZO4k099LEqB6XRMz3pH8bUe/HIo/BEotcgBr
	 EuO4P40a8AyYdv6x47xW7Cpb+8pIVN5eWNHBLn5MHTIw2n8ja4SqzCk50LXCV2462jnqe
	 1AFOltQ+qDDsSPXcQ7nWs8Kj+V8beLXqcS5cXJeKHjpD5679iQcfHzG9SjJVlN278Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2U0W9pI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E11606A31A;
	Wed, 28 Oct 2026 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2U0W9pI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAEA1F01825;
	Wed, 28 Oct 2026 17:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208565;
	bh=aA/Ay5VrT62EYQFEd5ayl30FU3z3SqZNkqKGjcGx0io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2U0W9pI/Z47NzNODADXAZvPEkjL8jWmnesk1niPVvHYpv0LW3JFoEDh959DAE18m
	 4DY1lZR+fCN8/7AxqbdznXzc/EmoeGMjR8XoNu2RTBOp88+sQduzIQGAEVKPZj5sdm
	 CQp1rSql3HdcxjoEFT50FoHWpbbamq3d1ss7vupM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/516] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Wed, 28 Oct 2026 17:55:16 +0100
Message-ID: <20261028170007.391218455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit d1ac915fb4184faad1b62148be50f317de7c24b5 ]

hci_register_dev() allocates an ID before calling dev_set_name().
If naming fails, it returns without releasing that ID. The device has
not been registered and hdev->id has not been assigned, so the normal
unregister path cannot release it.

Free the allocated ID before returning the naming error.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a718e38f3da31..81c6e292b6681 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3759,8 +3759,10 @@ int hci_register_dev(struct hci_dev *hdev)
 		return id;
 
 	error = dev_set_name(&hdev->dev, "hci%u", id);
-	if (error)
+	if (error) {
+		ida_free(&hci_index_ida, id);
 		return error;
+	}
 
 	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
-- 
2.53.0



