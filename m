Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5050534165B;
	Wed, 21 Jan 2026 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019892; cv=none; b=LXTyL3Rgw5WLeBtDEHX0VeD2A13h5qHoQ2kIOHlvAunVAHbPD8mCP4M60ZG/PfpfpmSf3gNDkMCoS6PgO4B/0IWWAWHpPUKeq4tZRSC0lI0M/UBlgLz7Y++BxUFxqfQUZDh2Zfo8zrNxTIqXmC19vssQOc1e6a1MlRWqEdu3zmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019892; c=relaxed/simple;
	bh=ODgy8vD2m1QY9Tm5QxQ+pwVNztO82QVAD1CLe21owNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FlxGWLLUMMcpcc3CvZgxOsw0EZiqgWSarfvpAfyQjqySc0W+FwsEe0qQ5hNhdfZgokbEvQsfR9y4pHbtjZ7RAwq8v9Gn52e0zwdcIDI8w5FW2lQcLN1dpqVKIbUppCQRMLVq8V5pKgVAcB1Kxte+lGD12bFaZTLKkiawhJ3Tt0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=If/3UyhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="If/3UyhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFCAC4CEF1;
	Wed, 21 Jan 2026 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019891;
	bh=ODgy8vD2m1QY9Tm5QxQ+pwVNztO82QVAD1CLe21owNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=If/3UyhBUlsQobHe+I3fqXhQ7Is26MFHpBp6tr1v7myT+Ec4Zm6U08gHUrxyfy5QV
	 UfjAcReBdCPi63EWVRIEeENez0XYA6+rfI+ij8nw0+MwFAF3ijpbw/9RBrOXIsKmMt
	 J/SGHdHvfhWrtLEfCQqwUo0eplto/G4psjue1Prc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Faccini <bfaccini@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Hyeonggon Yoo <hyeonggon.yoo@sk.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Len Brown <lenb@kernel.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 139/139] mm/fake-numa: handle cases with no SRAT info
Date: Wed, 21 Jan 2026 19:16:27 +0100
Message-ID: <20260121181416.462434999@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Faccini <bfaccini@nvidia.com>

commit 4c80187001d3e2876dfe7e011b9eac3b6270156f upstream.

Handle more gracefully cases where no SRAT information is available, like
in VMs with no Numa support, and allow fake-numa configuration to complete
successfully in these cases

Link: https://lkml.kernel.org/r/20250127171623.1523171-1-bfaccini@nvidia.com
Fixes: 63db8170bf34 (“mm/fake-numa: allow later numa node hotplug”)
Signed-off-by: Bruno Faccini <bfaccini@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <hyeonggon.yoo@sk.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/numa/srat.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -95,9 +95,13 @@ int __init fix_pxm_node_maps(int max_nid
 	int i, j, index = -1, count = 0;
 	nodemask_t nodes_to_enable;
 
-	if (numa_off || srat_disabled())
+	if (numa_off)
 		return -1;
 
+	/* no or incomplete node/PXM mapping set, nothing to do */
+	if (srat_disabled())
+		return 0;
+
 	/* find fake nodes PXM mapping */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (node_to_pxm_map[i] != PXM_INVAL) {
@@ -117,6 +121,11 @@ int __init fix_pxm_node_maps(int max_nid
 			}
 		}
 	}
+	if (index == -1) {
+		pr_debug("No node/PXM mapping has been set\n");
+		/* nothing more to be done */
+		return 0;
+	}
 	if (WARN(index != max_nid, "%d max nid  when expected %d\n",
 		      index, max_nid))
 		return -1;


