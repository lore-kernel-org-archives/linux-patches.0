Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789BE3B52EF;
	Wed, 30 Sep 2026 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783700; cv=none; b=IbCDa5Fb9iVEl0D7DW1IJR+ZrHEj+L2aT9GSngRgSvqJARoiohjAy1UIvG4MezL88q6lX4eTo2Nd6AXwie5DcNTGiZGtI5Nx7iDey2lsb2RV9q5p91CvDNCt7r+/I+lGH1gapVY16lqUtRBGDqN1pbXbQyKXqQp6ZqAo7QSEhYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783700; c=relaxed/simple;
	bh=df8t8WUTj+BupULBZhuA8jjLk7fc/9SD4jUJzPIgaM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hcg1HhftjGk0yvZeaRQvr4XDAKr0PfSC2AptImpd3ONkqaE2u69ld7rFKjbdH5fckE/KCIL1R0yFJA9+cMTIEi8Y2v6CB7e5z5cdkq32IDn/DuyiQNfmbrg8Cnb9jkVuJL4njqLIYHtD8wG67eYZxnopeN9pwG+JfN6YQ6Y/0PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB6Q0poy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB6Q0poy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C71F00893;
	Wed, 30 Sep 2026 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783696;
	bh=iAIH0mwth6s6oXMePdYGuW3uz8cc1ScsRXOjVWBFaJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB6Q0poycshPfOs6idWBMbIXKWaED1wlOS+wMGn1qei0rIWDogX3yU7aD5KAQEUax
	 HYdPzXNUrw3QUp7U3Os24yCu6AXzgU0AdkDsrKkT9SGy8hkcVYqF2z7pVUy8JjN0tN
	 bZu9ds3XpYbqQSZTsBVBw2QhHdo8wufqvxkxJv/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/595] Documentation: s390: correct spelling
Date: Wed, 30 Sep 2026 17:26:21 +0200
Message-ID: <20260930152358.183858888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ac56c666f80df0b1dc9c3ef53d0798b74629a116 ]

Correct spelling problems for Documentation/s390/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20230209071400.31476-16-rdunlap@infradead.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 4525a9110495 ("s390/pci/docs: Fix sriov_numvfs attribute name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/s390/pci.rst      | 4 ++--
 Documentation/s390/vfio-ccw.rst | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/s390/pci.rst b/Documentation/s390/pci.rst
index 8157f0cddbc24..a1a72a47dc960 100644
--- a/Documentation/s390/pci.rst
+++ b/Documentation/s390/pci.rst
@@ -51,7 +51,7 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 
   The slot entries are set up using the function identifier (FID) of the
   PCI function. The format depicted as XXXXXXXX above is 8 hexadecimal digits
-  with 0 padding and lower case hexadecimal digitis.
+  with 0 padding and lower case hexadecimal digits.
 
   - /sys/bus/pci/slots/XXXXXXXX/power
 
@@ -66,7 +66,7 @@ Entries specific to zPCI functions and entries that hold zPCI information.
 
   - function_handle
     Low-level identifier used for a configured PCI function.
-    It might be useful for debuging.
+    It might be useful for debugging.
 
   - pchid
     Model-dependent location of the I/O adapter.
diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index 8aad08a8b8a50..9bcd597e3de6d 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -176,7 +176,7 @@ The process of how these work together.
    Use the 'mdev_create' sysfs file, we need to manually create one (and
    only one for our case) mediated device.
 3. vfio_mdev.ko drives the mediated ccw device.
-   vfio_mdev is also the vfio device drvier. It will probe the mdev and
+   vfio_mdev is also the vfio device driver. It will probe the mdev and
    add it to an iommu_group and a vfio_group. Then we could pass through
    the mdev to a guest.
 
-- 
2.53.0



