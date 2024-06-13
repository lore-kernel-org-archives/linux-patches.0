Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC56714534A;
	Thu, 13 Jun 2024 12:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281254; cv=none; b=tN0guFNGmzjIs3HRBLK43fuQwT8ZIVqbTVg5vdWhz+OKJPKQDBh2CKIg456QKrRnP3SWmLwk8xhzfN8hUwFvXF2VP+rnB2/+Paf4YtZdk0V+82GfRnoyT0Q3UcltXVrDxJFIY2d4JrPwSaohyMERt7tBos1N+9+LbITy+WK1X6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281254; c=relaxed/simple;
	bh=FGbwGFldT1+7iRy88iIVd3eDtZHd9tFnBcTHdRELArY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtTKGN7bMDC86U4RSVlk/xwgQN4eTAnOouc2mrN+N0C6lt/ke6FY7iqXp5fLWkKvVtRi5Zg3vXrvK9VLXYwVMjy/mW2pFisbOBYQqR9xBh1SmtMDDKK+fpsp8rL57GTV4eHJIFYy1c3+8Zyx4IoO1HhkC6Ru5D+Vzm0ltnJW3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGUzWZ78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGUzWZ78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34409C32786;
	Thu, 13 Jun 2024 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281254;
	bh=FGbwGFldT1+7iRy88iIVd3eDtZHd9tFnBcTHdRELArY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGUzWZ78cO5b+PMo+RVPGETgdGke/dIvGT9bvGb7nlNjAXwcuyZOXwqlfIym13iVy
	 RaEIEF9R8U7OVxE0l/FOBG6ECc42+LsxjhHIHVdC31Q2VaVvgII+Oc5XkJ4WNeCPNZ
	 8/4knQhrTCDkAB2TVS8soQa1txBpBVqs4cYe9Bgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/317] docs: driver-api: fpga: avoid using UTF-8 chars
Date: Thu, 13 Jun 2024 13:33:03 +0200
Message-ID: <20240613113253.947039688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 758f74674bcb82e1ed1a0b5a56980f295183b546 ]

While UTF-8 characters can be used at the Linux documentation,
the best is to use them only when ASCII doesn't offer a good replacement.
So, replace the occurences of the following UTF-8 characters:

	- U+2014 ('—'): EM DASH

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Stable-dep-of: b7c0e1ecee40 ("fpga: region: add owner module and take its refcount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/driver-api/fpga/fpga-bridge.rst | 10 +++++-----
 Documentation/driver-api/fpga/fpga-mgr.rst    | 12 +++++------
 .../driver-api/fpga/fpga-programming.rst      |  8 ++++----
 Documentation/driver-api/fpga/fpga-region.rst | 20 +++++++++----------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/driver-api/fpga/fpga-bridge.rst b/Documentation/driver-api/fpga/fpga-bridge.rst
index 198aadafd3e7d..8d650b4e2ce6d 100644
--- a/Documentation/driver-api/fpga/fpga-bridge.rst
+++ b/Documentation/driver-api/fpga/fpga-bridge.rst
@@ -4,11 +4,11 @@ FPGA Bridge
 API to implement a new FPGA bridge
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-* struct fpga_bridge — The FPGA Bridge structure
-* struct fpga_bridge_ops — Low level Bridge driver ops
-* devm_fpga_bridge_create() — Allocate and init a bridge struct
-* fpga_bridge_register() — Register a bridge
-* fpga_bridge_unregister() — Unregister a bridge
+* struct fpga_bridge - The FPGA Bridge structure
+* struct fpga_bridge_ops - Low level Bridge driver ops
+* devm_fpga_bridge_create() - Allocate and init a bridge struct
+* fpga_bridge_register() - Register a bridge
+* fpga_bridge_unregister() - Unregister a bridge
 
 .. kernel-doc:: include/linux/fpga/fpga-bridge.h
    :functions: fpga_bridge
diff --git a/Documentation/driver-api/fpga/fpga-mgr.rst b/Documentation/driver-api/fpga/fpga-mgr.rst
index 917ee22db429d..4d926b452cb35 100644
--- a/Documentation/driver-api/fpga/fpga-mgr.rst
+++ b/Documentation/driver-api/fpga/fpga-mgr.rst
@@ -101,12 +101,12 @@ in state.
 API for implementing a new FPGA Manager driver
 ----------------------------------------------
 
-* ``fpga_mgr_states`` —  Values for :c:expr:`fpga_manager->state`.
-* struct fpga_manager —  the FPGA manager struct
-* struct fpga_manager_ops —  Low level FPGA manager driver ops
-* devm_fpga_mgr_create() —  Allocate and init a manager struct
-* fpga_mgr_register() —  Register an FPGA manager
-* fpga_mgr_unregister() —  Unregister an FPGA manager
+* ``fpga_mgr_states`` -  Values for :c:expr:`fpga_manager->state`.
+* struct fpga_manager -  the FPGA manager struct
+* struct fpga_manager_ops -  Low level FPGA manager driver ops
+* devm_fpga_mgr_create() -  Allocate and init a manager struct
+* fpga_mgr_register() -  Register an FPGA manager
+* fpga_mgr_unregister() -  Unregister an FPGA manager
 
 .. kernel-doc:: include/linux/fpga/fpga-mgr.h
    :functions: fpga_mgr_states
diff --git a/Documentation/driver-api/fpga/fpga-programming.rst b/Documentation/driver-api/fpga/fpga-programming.rst
index 002392dab04f7..fb4da4240e961 100644
--- a/Documentation/driver-api/fpga/fpga-programming.rst
+++ b/Documentation/driver-api/fpga/fpga-programming.rst
@@ -84,10 +84,10 @@ will generate that list.  Here's some sample code of what to do next::
 API for programming an FPGA
 ---------------------------
 
-* fpga_region_program_fpga() —  Program an FPGA
-* fpga_image_info() —  Specifies what FPGA image to program
-* fpga_image_info_alloc() —  Allocate an FPGA image info struct
-* fpga_image_info_free() —  Free an FPGA image info struct
+* fpga_region_program_fpga() -  Program an FPGA
+* fpga_image_info() -  Specifies what FPGA image to program
+* fpga_image_info_alloc() -  Allocate an FPGA image info struct
+* fpga_image_info_free() -  Free an FPGA image info struct
 
 .. kernel-doc:: drivers/fpga/fpga-region.c
    :functions: fpga_region_program_fpga
diff --git a/Documentation/driver-api/fpga/fpga-region.rst b/Documentation/driver-api/fpga/fpga-region.rst
index 363a8171ab0a5..2636a27c11b24 100644
--- a/Documentation/driver-api/fpga/fpga-region.rst
+++ b/Documentation/driver-api/fpga/fpga-region.rst
@@ -45,19 +45,19 @@ An example of usage can be seen in the probe function of [#f2]_.
 API to add a new FPGA region
 ----------------------------
 
-* struct fpga_region — The FPGA region struct
-* devm_fpga_region_create() — Allocate and init a region struct
-* fpga_region_register() —  Register an FPGA region
-* fpga_region_unregister() —  Unregister an FPGA region
+* struct fpga_region - The FPGA region struct
+* devm_fpga_region_create() - Allocate and init a region struct
+* fpga_region_register() -  Register an FPGA region
+* fpga_region_unregister() -  Unregister an FPGA region
 
 The FPGA region's probe function will need to get a reference to the FPGA
 Manager it will be using to do the programming.  This usually would happen
 during the region's probe function.
 
-* fpga_mgr_get() — Get a reference to an FPGA manager, raise ref count
-* of_fpga_mgr_get() —  Get a reference to an FPGA manager, raise ref count,
+* fpga_mgr_get() - Get a reference to an FPGA manager, raise ref count
+* of_fpga_mgr_get() -  Get a reference to an FPGA manager, raise ref count,
   given a device node.
-* fpga_mgr_put() — Put an FPGA manager
+* fpga_mgr_put() - Put an FPGA manager
 
 The FPGA region will need to specify which bridges to control while programming
 the FPGA.  The region driver can build a list of bridges during probe time
@@ -66,11 +66,11 @@ the list of bridges to program just before programming
 (:c:expr:`fpga_region->get_bridges`).  The FPGA bridge framework supplies the
 following APIs to handle building or tearing down that list.
 
-* fpga_bridge_get_to_list() — Get a ref of an FPGA bridge, add it to a
+* fpga_bridge_get_to_list() - Get a ref of an FPGA bridge, add it to a
   list
-* of_fpga_bridge_get_to_list() — Get a ref of an FPGA bridge, add it to a
+* of_fpga_bridge_get_to_list() - Get a ref of an FPGA bridge, add it to a
   list, given a device node
-* fpga_bridges_put() — Given a list of bridges, put them
+* fpga_bridges_put() - Given a list of bridges, put them
 
 .. kernel-doc:: include/linux/fpga/fpga-region.h
    :functions: fpga_region
-- 
2.43.0



