Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8C4DEC26;
	Wed, 30 Sep 2026 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792317; cv=none; b=s2fQM8IlQGo9hwlrenLWeCUUCIXaUp5sgRAQXDJhCYCI2Wgzlr3ePkoUHmp+UudRQ2gGQoovV2EVFBEyYNV7lPCryYhXHd/wWNAHsGXK16h46N9/lzKGDCTpSTiyv2EoTLIuCxlk3S/a4v6FxfL911+cyaC0tukN6EfOxGL3x3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792317; c=relaxed/simple;
	bh=eXBGbWfMvbkYZ8EVwEZC2rrmpRFFCM6Toa5YWl0wCMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tF0aetW5lBHnhQMu3SrUlS8Tpt9lfMoEpnH3ymwILIUKBDii6hhnxOaQdO8PTNtsbAx0O9Z+imPwaNSjDe3v6bCdY/aaoAUGMFKtWkwSLmVaeA7Km9RaRWTjSkzwYgvaF+WwmgrZvIljswnYLIi1aRUeh4t5nTXgW2r0DhfNgIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tE587Oqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tE587Oqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EBA1F000FF;
	Wed, 30 Sep 2026 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792316;
	bh=X0NwXxbdNucQcX0dXdzjLdrFxHF5Y6cRnM9/MiOmtn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tE587OqnxxmRvMwE4SLuZqbSFxBU30BFijyuuba71iNHpHHBDs1XJ4uL8Nxyi7U/h
	 AA7KWt9DDoF7PP10RC8JZxSu6cesJ/OsYbnYNuY++3O3MMzb17KDUuSlR3Ral/l/us
	 nG1u1WtTMM3QFs9kECJELzmZOHI5YBXyRHunBVWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 605/752] Documentation: s390: correct spelling
Date: Wed, 30 Sep 2026 17:27:55 +0200
Message-ID: <20260930152411.374338266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



