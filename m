Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C246248BD1;
	Wed, 15 Jan 2025 10:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938602; cv=none; b=VZ1MsUYLthBJBhS48slsH+4WGjKycsb3GvhBFHkJT53SjW8T9ftzIizcDTtq2PcapqfiMI8TzVc1RJ9HCt8FQk+Ubh8q3i/u5TWXhAymUpbdCpn/2aOAK8ykC57/RmMoHNStOtzMb1AXnFesfpH6JuGfHXbqsz3tZo0SC+hWXjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938602; c=relaxed/simple;
	bh=YfZhHAcUjcC3N5Ab1OR0ojCNwV804L4m9kzDFLqb3nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9PRmSzyGZGLmHBD/00RDNeegoh4vc1s4TYxdv5SN/z3Y8goIteFFvZivJ4JwoDT3KB5YBpopW1rdmRKTXjytit5JOmHsbTq7Sfa+K/S0dvOFhlsLz+LqBCHHcRamBKBPvTXLwO7d3nX/4mI6JSYAgBD3iwdb0tELQZ/jWcmvks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjupiRm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjupiRm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0040C4CEDF;
	Wed, 15 Jan 2025 10:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938602;
	bh=YfZhHAcUjcC3N5Ab1OR0ojCNwV804L4m9kzDFLqb3nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjupiRm+Ycz+JmqDnaXs5EElXcH3KfEOnFFZkHh/zc4czryZ1dNOsezCVQBnmr5fA
	 33UHsClmZvvV+LzXzRJZYbvC3CYv/XY+8yY3xECPPBzMmhGpO3+RVyCNdf5A4nVscg
	 MVib2K5fFFrntGFiu23/l6XgxCYY71KgUnukn81c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: [PATCH 6.6 039/129] memblock tests: fix implicit declaration of function numa_valid_node
Date: Wed, 15 Jan 2025 11:36:54 +0100
Message-ID: <20250115103555.929360778@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit 9364a7e40d54e6858479f0a96e1a04aa1204be16 upstream.

commit 8043832e2a12 ("memblock: use numa_valid_node() helper to check
for invalid node ID") introduce a new helper numa_valid_node(), which is
not defined in memblock tests.

Let's add it in the corresponding header file.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Mike Rapoport (IBM) <rppt@kernel.org>
Link: https://lore.kernel.org/r/20240624015432.31134-1-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/numa.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/include/linux/numa.h
+++ b/tools/include/linux/numa.h
@@ -13,4 +13,9 @@
 
 #define	NUMA_NO_NODE	(-1)
 
+static inline bool numa_valid_node(int nid)
+{
+	return nid >= 0 && nid < MAX_NUMNODES;
+}
+
 #endif /* _LINUX_NUMA_H */


