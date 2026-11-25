Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618464;
	b=3CoN8IKgy4oe5ljr297ZMUhMjuerT5Wa203jAVHyHBhD8kcI4/yBh5wgEJ4tExVjPkKG
	 1Ygp7B/tudm+cu4r/uNig5ejI59HMjfl71UGy1tbXpx/Dcoo7Fgp1UVd4JF17lVuuHS3j
	 xMNuQf+kqTMYA9GWzWtPkksojRRF6bf2OiMwQ7Bc7Mzv737y3x8OHwfhsXllZhQ5vxaJ6
	 l/9zyaq8oBR7VcdoG2HYHR9jZB6FYLklaDLiAjit5lZHgBc0+nE0LMJcFid6vo+UKP8DF
	 /hM7TUVUnrB228nT7KFcrZYJuEuh5csuFHnZO1laRZ9+VBbvSGb6tlgPrjTgmM6LFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JrHhFwA4BGAxXd1+vPfxmHxALG/gJxKYvo9wTtb9+Q=;
	b=1IujKJOX2+16KcndbhFAqSvfKCPviGycMnHE6dBCf43X4bG1J4G+28DM1ZXvgxd2L2d4
	 q09B8NvKte6hjPi5OaWmP8RR1oNbWWtPtXxu/oZLOKKYaHl3k1aq+x/nA/VCWTluy8Csh
	 0dxxbAQmMBZ/SxCJyovp1IQvfu9d/qRZkgt+vnEi6EtlTyTkCqLsP1ZnVOjkKr7FipGEB
	 7uXpwiGMMe6caXLI+XoTgMTjq5EvfQBR0Uu7+F3D9gHnV3UXx1/vCQ2vOwyTScgJxFDA3
	 VAvgOYbawNecRk6+VdxsL23ZcEbwDDWxNISf2BIdC52n5w1iPyiHJ5Xtn92n9gzjKGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hS/M8ecl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F624606A31E;
	Wed, 25 Nov 2026 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hS/M8ecl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A621F000D3;
	Wed, 25 Nov 2026 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618463;
	bh=6JrHhFwA4BGAxXd1+vPfxmHxALG/gJxKYvo9wTtb9+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hS/M8ecl7XkMyeoRysMRmJnFc0qdehWUIrGyXKDLew4Oesww1gONgZogDUPLyEW/K
	 BZMEFeFMYCxvzGcYLveY6rJEKcaQnQZfMCrumqUj6z10aw75TLk6a7zSkZ3iZWEzH6
	 2iEOhCKZIwvySPKwcBrtfz4hv+BtYL4dF9iabpJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 0288/1005] ACPI: scan: Print the offline failure message in acpi_bus_offline()
Date: Wed, 25 Nov 2026 15:27:06 +0100
Message-ID: <20261125143828.486453745@linuxfoundation.org>
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

[ Upstream commit b9ea1e921c2721546f53270cffdc6866e20576dd ]

When a physical node of an ACPI device being hot-removed cannot be
offlined, acpi_bus_offline() passes the physical device back to
acpi_scan_try_to_offline() through ret_p and the latter prints
"Offline failed." for it after the namespace walk.  By then
physical_node_lock is not held anymore, so the device may have been
unbound from its ACPI companion and freed in the meantime.

Print the message in acpi_bus_offline() when device_offline() fails in
the second pass, while physical_node_lock keeps the device bound to its
ACPI companion and so the reference taken by acpi_bind_one() is still
held.  acpi_scan_try_to_offline() only needs to know that something
could not be offlined, so pass the ACPI device back through ret_p
instead, like in the "Offline disabled." case.

Fixes: 303bfdb1a14d ("ACPI / scan: Add second pass of companion offlining to hot-remove code")
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261029034507.2721580-2-sashal@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e8189849eaa60..c90734a48583e 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -165,8 +165,9 @@ static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
 		if (ret >= 0) {
 			pn->put_online = !ret;
 		} else {
-			*ret_p = pn->dev;
+			*ret_p = &device->dev;
 			if (second_pass) {
+				dev_warn(pn->dev, "Offline failed.\n");
 				status = AE_ERROR;
 				break;
 			}
@@ -235,7 +236,6 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
 					 (void **)&errdev);
 
 		if (errdev) {
-			dev_warn(errdev, "Offline failed.\n");
 			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
 					    ACPI_UINT32_MAX, acpi_bus_online,
-- 
2.53.0



