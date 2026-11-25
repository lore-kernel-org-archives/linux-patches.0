Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618035;
	b=IhusnEhCk3PgUAMEgghiVm7Wya/fr+Q0aszckLFbmSKf9OiX8Rz2QqF5J+K2jVvYbA1/
	 CD140p2oHyBF2oxLl8ItPXGqnw9J529UT6rzVv59z0Cxlf0uhFuL7CrT4yG8cVemluOo/
	 6P5MOGHcbNYChCp8XY8yTOvLDO7uKcuLYr/yG7iLTDDEJBpjjOBwkMCuXB/h5iu2L9WPc
	 0NdpOrcife6It+BylwAfsRQd2vvTUn8LeTmBd4wIFk6XPhgmRm5iNFBCaGiPTQ+uk25xT
	 ugOPBuUY39WrdYHusLhY0XdPKfXGMjnWBh8dAZ87WOP01OvzRcavGb/7/bRdYoHLFUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcmc8tRK55AJFLvbZKdbHFUgTmnRUyKNfrfynEVkZMg=;
	b=aXi4s1wkojR3i98E2OkgHWAm9OuFwfkaaiKOz94R+tGAB4+hHvD55YfoSD4Cw3OC8U81
	 J+5jpcSZeGP18b3eZGp7uqTZFHsEZEU4h8aCZINxbMFs0Ju5kQN1hLnwi555qmhr33uZl
	 oIdyGerDVlzbwVaThGoQLXn8VwsBYYNIA8ZCBju676Ek8CL+jch4/959AJKdW6ijevxlL
	 LSMlJB8oTkPGmRtQKNel/VAXKDjkAolLqbqbbDb1yOkMsg2f23AJyJhT4hzzRhK8wZf5h
	 Ybj8haHRELjI6ryR0BJGVSDM+faxJaKp4WgjwOFXkRXy44oZvk+0v2Hxmlj840Q22aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qr5sv+qC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F3606A323;
	Wed, 25 Nov 2026 14:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qr5sv+qC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0A11F000CA;
	Wed, 25 Nov 2026 14:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618035;
	bh=gcmc8tRK55AJFLvbZKdbHFUgTmnRUyKNfrfynEVkZMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr5sv+qCCIQfauQnHrmAZWZFgUOogsMaV8yflDFW3BO4eI7AeN5cMh4ac/CVr5dlW
	 8nZccgFuW/Jmdr3jQmDdrQQLE6HUFjDYNVPMGksKYjTLZyoy8JxWlpaU+eZXGk70nm
	 nAOFC3JslZBHhpJSA+jQvx0we1yvuWfD7GC1muds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0151/1005] virtio-spi: Fix virtio_spi_config kernel-doc
Date: Wed, 25 Nov 2026 15:24:49 +0100
Message-ID: <20261125143825.271319806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 62b0a9b11e94a4bc7f67c89348d0619cba82b54b ]

struct virtio_spi_config contains max_cs_inactive_ns, but its
kernel-doc describes max_cs_incative_ns. This leaves the real member
undescribed and adds a nonexistent member to the generated
documentation.

Correct the spelling.

Fixes: 6a1f3390fafe ("virtio-spi: Add virtio-spi.h")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260909064938.90995-1-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/virtio_spi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_spi.h b/include/uapi/linux/virtio_spi.h
index 8ab3c970cdd31..459c2276c938c 100644
--- a/include/uapi/linux/virtio_spi.h
+++ b/include/uapi/linux/virtio_spi.h
@@ -73,7 +73,7 @@
  * @max_cs_hold_ns: the maximum delay supported before chipselect is deasserted,
  *   in ns unit, 0 means delay is not supported to introduce before chipselect
  *   is deasserted.
- * @max_cs_incative_ns: maximum delay supported after chipselect is deasserted,
+ * @max_cs_inactive_ns: maximum delay supported after chipselect is deasserted,
  *   in ns unit, 0 means delay is not supported to introduce after chipselect is
  *   deasserted.
  */
-- 
2.53.0



