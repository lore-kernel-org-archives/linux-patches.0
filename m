Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704351;
	b=qQO5zT0jUkJIwvwvo1FtNXSXkTZ6jpoCzorescOpwjuMVwlk3cdbNgiMQBZLeULnGxDT
	 U0Iiu8u9dOFiv21r22ODYXx3vUpeXvLApAaGPbiKVt3lyjI/jtJzvGZapSHO2O+eXL51G
	 WEBzA7UZMcxFgWD0MGvF/97dlmK/EZrplSDHzZo0TznAHIHlDXas2uZZDwyjkchxV3MK9
	 0eDF7H1As6pgr/QOF2mMiasQ89lNpJ0kbYxgR3p3gVMsVDkfvQcnNQTsQjbKkBDgHe2RF
	 4GhPM8EET/Lr3eYzsXhCOwrPZKqv+VbVDDnhS9KKn5woKL+Fk46+GIpbAs76eCuS1Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wYW4b8+vMzSix+75O19bF7iEcb+H2aRcwoC6RCO0LhU=;
	b=g+GlXkZp3tecTUbPqjnKIsI0B/rf7ScfS3ZOzl0aGZwpjbd3Y+RiceclWiFErGNn7vTY
	 7gPXI3hCj9gMhzHLeCA89/fDCz5cFtkRN8Heh8V/PBZo0FOKohT1+ILbBx/LcGLugNzN6
	 i5JDeQY46RS+qn27+biBU1GgShrT7VUByGEusnqJ3xDqjjJtKIouGMbl/DpG94pu/R5Ec
	 FHSzm+eCSBU7JQiueSr0GJQpKvm2XHVYFFJzOh+IerIYYqzhVkHfcPLi9eggpkBx5r0ez
	 G3n/k0Ds6eaOcWbs0h56GBsA6Rh2ipwpIERvHz9t9MhnPfLRuui2LKQTqAeWMc/o9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNPw1lOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7772606A32A;
	Thu, 26 Nov 2026 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNPw1lOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C331F000C6;
	Thu, 26 Nov 2026 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704351;
	bh=wYW4b8+vMzSix+75O19bF7iEcb+H2aRcwoC6RCO0LhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNPw1lOMXQ1gA5T/neesOST1/FGwuk8uQDCRhS3vFWqiKJUJLnSuskpLWCvpDRcA+
	 ncqWrRl82YrOiN1Ol9hqwfqxIGkYZ3YKH4ip+GwdvZMuKCelcWpa/HRBy5EUKWKnnW
	 jbewMGV8G6N3lRCFSSaMojalMQMcU3c2pG2Au3DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/265] vhost: Allow null msg.size on VHOST_IOTLB_INVALIDATE
Date: Thu, 26 Nov 2026 15:36:19 +0100
Message-ID: <20261126143608.513377774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Eric Auger <eric.auger@redhat.com>

[ Upstream commit ca50ec377c2e94b0a9f8735de2856cd0f13beab4 ]

Commit e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb
entries") Forbade vhost iotlb msg with null size to prevent entries
with size = start = 0 and last = ULONG_MAX to end up in the iotlb.

Then commit 95932ab2ea07 ("vhost: allow batching hint without size")
only applied the check for VHOST_IOTLB_UPDATE and VHOST_IOTLB_INVALIDATE
message types to fix a regression observed with batching hit.

Still, the introduction of that check introduced a regression for
some users attempting to invalidate the whole ULONG_MAX range by
setting the size to 0. This is the case with qemu/smmuv3/vhost
integration which does not work anymore. It Looks safe to partially
revert the original commit and allow VHOST_IOTLB_INVALIDATE messages
with null size. vhost_iotlb_del_range() will compute a correct end
iova. Same for vhost_vdpa_iotlb_unmap().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")
Cc: stable@vger.kernel.org # v5.17+
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230927140544.205088-1-eric.auger@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: b179f21d2d8a ("vhost: reject invalid IOTLB update permissions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7cf2b5a2cceeb..f1f35f239354d 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1171,9 +1171,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if ((msg.type == VHOST_IOTLB_UPDATE ||
-	     msg.type == VHOST_IOTLB_INVALIDATE) &&
-	     msg.size == 0) {
+	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.53.0



