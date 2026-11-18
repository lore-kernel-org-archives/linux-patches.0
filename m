Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050916;
	b=ThrAm8yLEaj00G2G8xFvU0DruXrw6YZpeWDuKwcfSSkK0jcw20/Ayyx7tRGWVLu3dLx6
	 F2t/KZzmLp/qsdeQgNjhB8ZkWOqRO5WpFHb8D/pzZQu6NAXm8XUKMttCOwOqW3Tcvk1Vo
	 XOMbIOMtGWTCe3JRkNHQlcrYiFRf4OuM8NX4gqk3HJmVzem2xlbXE8X5/kqRmFhKNAOeW
	 0o7D0FgAzFbPqwgI9wMWnz0vuk8KEaZRgVK0+6q2UFaYky7qQjqUkov/87MUGKser+h7R
	 XveNEg7NFvDsip2TYcklQpcUxOEIysoZnkfwsK9WQ/aFSYHA6IUweSE0jtpj+mE8HjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PJaPilJiuxDDWvMMy3az1LwjZVOZx3T+6Qtg2kkrMeA=;
	b=1xwtDQpgRsJQuajfM7jXqroNgEaobYECNNXwiLPQbUZcpSA0+cdHyulkbNCA9mko5yXA
	 fGIOH8lgBjkxatRGvT+SJczaoW7oykxzuXdB1yqF7pIMIeWFT8ZD0N+r7uW0qe+wVztqB
	 /iWQ7uFvVdkWLI4G2sff/b7M8Pmm1czCeDzsdpjlFYHsrNV6CeRKbbbSbQbGhwfQ7BcmO
	 MEvurm6SWK4YZ+TKQ95dyHDHzTq3Fy+146AEHz8m9ZqRuywpHdL11DwFd2kXCPfR6fkqT
	 ty9rZMwd5s7AK3MARacu56vJ9SRS8gkLpXOwFuduuUzXXKNhIBDilV+jRBHPGHfc/xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnARgtdM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE53C606A32C;
	Thu, 19 Nov 2026 01:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnARgtdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9EE1F000C4;
	Thu, 19 Nov 2026 01:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050915;
	bh=PJaPilJiuxDDWvMMy3az1LwjZVOZx3T+6Qtg2kkrMeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnARgtdMefNDg+rnZLbNrgx0qL3OyACrcJUkrHSyhloXCuKpJsI7DqAAI2IUwHia+
	 UKjVAvkiQJfPDuxrOTm9BL7PkoGiJi4MruG+IobXywu4sc981H0vvrKFotaNUg0H2N
	 a2R0/UDDiDxnbxxt9L031gGzA1TkzJq76w4exMKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0023/2214] drm/amdgpu: Limit BO list entry count to prevent resource exhaustion
Date: Wed, 18 Nov 2026 15:28:19 +0100
Message-ID: <20261118150011.051880327@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.Zhang <Jesse.Zhang@amd.com>

commit 6270b1a5dab94665d7adce3dc78bc9066ed28bdd upstream.

Userspace can pass an arbitrary number of BO list entries via the
bo_number field. Although the previous multiplication overflow check
prevents out-of-bounds allocation, a large number of entries could still
cause excessive memory allocation (up to potentially gigabytes) and
unnecessarily long list processing times.

Introduce a hard limit of 128k entries per BO list, which is more than
sufficient for any realistic use case (e.g., a single list containing all
buffers in a large scene). This prevents memory exhaustion attacks and
ensures predictable performance.

Return -EINVAL if the requested entry count exceeds the limit

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 688b87d39e0aa8135105b40dc167d74b5ada5332)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -35,6 +35,7 @@
 
 #define AMDGPU_BO_LIST_MAX_PRIORITY	32u
 #define AMDGPU_BO_LIST_NUM_BUCKETS	(AMDGPU_BO_LIST_MAX_PRIORITY + 1)
+#define AMDGPU_BO_LIST_MAX_ENTRIES	(128 * 1024)
 
 static void amdgpu_bo_list_free_rcu(struct rcu_head *rcu)
 {
@@ -230,6 +231,9 @@ int amdgpu_bo_create_list_entry_array(st
 	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
 
+	if (bo_number > AMDGPU_BO_LIST_MAX_ENTRIES)
+		return -EINVAL;
+
 	/* copy the handle array from userspace to a kernel buffer */
 	if (likely(info_size == bo_info_size)) {
 		info = vmemdup_array_user(uptr, bo_number, info_size);


