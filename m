Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215153;
	b=4ifOkXjU+DzryzGKFo0JvyIdWlHQY0CJJJ513RQcuNhsfzlNR2obDT52esvLD5mXshyb
	 5IO9HKfiwD5qvWET5U04KvTnKAqFetXDveCJwJO6Tvb/4bQK6lNgxc04CjpBfe0M8c1Wh
	 AfrRHQXQN5m06c5bKJXN1ZZNCRtP6XENBFkn6SvqOJVOfRXonCCwa6HRp87UWbZyMz4d2
	 NCfq1DhcE+h8jQE96qGOzo8zrI9kcncVj+eKdJOlUIXwJPXuw1rhUjFifj14y9pXB//ew
	 mHA61ykcv0F9sFzo550QC7A6PeGumeEyxmQj49hF0PGWk9DoE3h4/jsq/oweutBe/IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ThENVLXnHDil3cm5qbLoRIOjbV94UmvajAxaYx+UG78=;
	b=yD2M0GFGLy9rq6tu1sku7KFvOoA8tx07bezw58Fr0pgMv28hgieAshFulcjJSZ+9DF0P
	 lm5wSQBA6eBCN0+NwmJWF+CO0q0agX2HdCnkaDXBcQ49znes6HuhMRKKG9S4hlcjRSkTH
	 WEod4T790VB/HH5Iy6t/GeaIk8avqsSmyzeok3h90i97tDI6AMjz34nLECEtdfTJTSoV7
	 sGZNXrCHkdeKSyHxNwpYysjcMO3fpUhu1pO2q6zFMrvpxW5ddCTyg7LMDGxKOMcQNTFgm
	 HtM176OSn0muAgfHvqkVkjekCdfAartk4meR+AhU5+NGSiR9utx5KFNlfoJ7+ZnaaCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPNQ6ZXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F1606A32C;
	Wed, 28 Oct 2026 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPNQ6ZXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2271F01825;
	Wed, 28 Oct 2026 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215153;
	bh=ThENVLXnHDil3cm5qbLoRIOjbV94UmvajAxaYx+UG78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPNQ6ZXo18lnfQRQ69jy7hk0JOTTt4/d95oFBLa3L5hCiAVmyCU+qNaJ/SCfIc9Ir
	 D6LYMjfqbR9V+EQddaORUk7geIsxZ35bzRpFbiF+n4GTFS6hzwhQXVfbrTAtpreLQE
	 w6ScDbzQZmTtUZh/NTjuIHqP8bMTCUOrrUFXAuY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1111/1887] drm/amdkfd: Add upper bound check for num_of_nodes
Date: Wed, 28 Oct 2026 17:53:27 +0100
Message-ID: <20261028170524.686954065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Alysa Liu <Alysa.Liu@amd.com>

[ Upstream commit 74b73fa56a395d46745e4f245225963e9f8be7f1 ]

drm/amdkfd: Add upper bound check for num_of_nodes
in kfd_ioctl_get_process_apertures_new.

Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 98ff46a5ea090c14d2cdb4f5b993b05d74f3949f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c  |  3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h     |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 4853a8b43f08b..38652724f3d9a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -772,6 +772,9 @@ static int kfd_ioctl_get_process_apertures_new(struct file *filp,
 		goto out_unlock;
 	}
 
+	if (args->num_of_nodes > kfd_topology_get_num_devices())
+		return -EINVAL;
+
 	/* Fill in process-aperture information for all available
 	 * nodes, but not more than args->num_of_nodes as that is
 	 * the amount of memory allocated by user
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index ac4a344bacd81..6af058e146ed8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1048,6 +1048,7 @@ struct kfd_dev *kfd_device_by_id(uint32_t gpu_id);
 struct kfd_dev *kfd_device_by_pci_dev(const struct pci_dev *pdev);
 struct kfd_dev *kfd_device_by_adev(const struct amdgpu_device *adev);
 int kfd_topology_enum_kfd_devices(uint8_t idx, struct kfd_dev **kdev);
+uint32_t kfd_topology_get_num_devices(void);
 int kfd_numa_node_to_apic_id(int numa_node_id);
 void kfd_double_confirm_iommu_support(struct kfd_dev *gpu);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index d841200a405b5..1960792da0665 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -2109,6 +2109,17 @@ int kfd_topology_remove_device(struct kfd_dev *gpu)
 	return res;
 }
 
+uint32_t kfd_topology_get_num_devices(void)
+{
+	uint32_t num_devices;
+
+	down_read(&topology_lock);
+	num_devices = sys_props.num_devices;
+	up_read(&topology_lock);
+
+	return num_devices;
+}
+
 /* kfd_topology_enum_kfd_devices - Enumerate through all devices in KFD
  *	topology. If GPU device is found @idx, then valid kfd_dev pointer is
  *	returned through @kdev
-- 
2.53.0



