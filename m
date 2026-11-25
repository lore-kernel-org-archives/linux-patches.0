Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618284;
	b=iKEbCz4Oue6uY3HZHJ6NUUBcZCZhKORDsHKJRej0qaJLjEmXqHaBBdafhaWL+S+YUdrG
	 KnRMOU5OF28OpW00NOCsE1ZOxzJoE61dr0sFFObHluhYx4vr+A4UnAqvf9VQxgJHwdlJ5
	 8cZHYUO89Y+V7TDk3KGzvXghMJ/Ph5Ds1OBPd1wdZOl++isljzjkci3HWewIyEqMfYiAJ
	 5pBoDxE2u3k/pE3DULfwYzRp9axTD9MilYUghWGW/i4N65wF1AfqUFTiQOa9fHgN5/hNK
	 +1U3xebK0SeXgxHIk6PvuooLABiQwZVU8nE0VJ3yCjqVE8qDtwIgOny/zVHVlpCi//g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fcav5qdwyS/E+JNRgev5qaqGgKdD6zPEzIZdDGSEuA=;
	b=bfzUDOHlYK/YH1MZKj0/tcgEFDA8+T6Ubn/EckaaA/45MnCg3z7ruUusTpY4tHQmxvrU
	 Sb47qf+mL3airNiBpwj54+3hbHqJR1iaGoyidOrfRaCreC+bryOD4jGJ7zOTn5KQQ7aOX
	 hzUnvVjrNMAo+MvFhYIf341CvyfQU3AD+APd8/twy5pNGHBcbhONXGh5fRuUjtj6iwcrg
	 PhedVtI8cwnJ4iXCj1QYMJUuubCOFaE34UIeToTIwU4QolRDaWiJYdr/oA7AyxT+SQiBv
	 h4rpR2JcfekLZU2MPA4QSa3sSUr5oKuu3nVa61hMEBnzOOMTn/IMd/Rfld9Dv6i1biw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNwKbDPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D751F606A321;
	Wed, 25 Nov 2026 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nNwKbDPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F511F000CA;
	Wed, 25 Nov 2026 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618284;
	bh=0fcav5qdwyS/E+JNRgev5qaqGgKdD6zPEzIZdDGSEuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNwKbDPFNxid0jHlLv5aSqP/WSQEftjqQ80I2Oosof6vvrxfpTfk7D/F+pUovWBNi
	 DvSZl37zIRrmAdyaekHhWCRXUb7ITkk8NKNRPXyZuP+Qh52br5ZYZ3/apnGLPkZUum
	 V7KRN6pRnl6coTN/ycRNDZ0dkb7RFO32hGw15Ujc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0232/1005] vhost: reject backend enable without a kick file
Date: Wed, 25 Nov 2026 15:26:10 +0100
Message-ID: <20261125143827.174015161@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 509f6bd229e94fc39506e01be692c4aa22338b49 ]

Enabling a backend without VHOST_SET_VRING_KICK dereferences a NULL
vq->kick in vhost_poll_start(). Reject the request with -EINVAL.

Fixes: 264ee5aa81ec ("tools/virtio: Add --reset")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261011-fix-null-pointer-in-vhost_test_set_backend-v1-1-60b2f12d64c6@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 24514c8fdee49..15b19e07f811f 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -287,6 +287,10 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
 		r = -EFAULT;
 		goto err_vq;
 	}
+	if (enable && !vq->kick) {
+		r = -EINVAL;
+		goto err_vq;
+	}
 	if (!enable) {
 		vhost_poll_stop(&vq->poll);
 		backend = vhost_vq_get_backend(vq);
-- 
2.53.0



