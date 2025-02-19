Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ADF28629E;
	Wed, 19 Feb 2025 09:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957052; cv=none; b=NiEqjk3soJ3xnERgKx/+d9UyMHHCbeYRclui7Frxhm3cJJTSYLZma8mxD7zPrHbutL6F/nC9QvUfwdrAtQMSiDNnGHT08DvoiZVZuEtlDeoOPe3MF3qFOxmgMcQe+cdJV0hQ3nld4FAuMfibldoq5JgHgrh700MS8tfv9renbc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957052; c=relaxed/simple;
	bh=Ym8dyB+BK6nGwZC15/HJxOSWQUeOZJPNZ5g0F2ubQnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXtCVDJJstNA1v+hyt7QGxoHyt89oZ2N/mw8A8XSdqaTe958628milz2JMlTena/vBdC3x6jmuSmfKVBVIS4JdqG6hMf+n4ci6otF5S3VLuuHSmMtkke4pyAr2W972cTyLwlj1/bt0y4XhKwzCNz/BZ63+dlZ8AgKBsxyPHVEgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnoPjqrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnoPjqrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3408FC4CEE7;
	Wed, 19 Feb 2025 09:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957052;
	bh=Ym8dyB+BK6nGwZC15/HJxOSWQUeOZJPNZ5g0F2ubQnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnoPjqrRC9CjFKxvfnqZAPrN7oEZXynCPp992HHLlKLaj1ttIkA6GIyOhs+DIxKK5
	 brwyorv7UE0H9OfVzGTPGecYALtZ3S/U6ewTzqVprEhsrNSEIDiH+Rr6Hnrs8JWqj2
	 1JBMfhskvqxNT/aBTHrIxEDIkmK+/fp18REvbKa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 392/578] nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
Date: Wed, 19 Feb 2025 09:26:36 +0100
Message-ID: <20250219082708.444871918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit 11cb3529d18514f7d28ad2190533192aedefd761 upstream.

On the TUXEDO InfinityBook Pro Gen9 Intel, a Samsung 990 Evo NVMe leads to
a high power consumption in s2idle sleep (4 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a sleep with
a lower power consumption, typically around 1.2 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3105,6 +3105,7 @@ static unsigned long check_vendor_combin
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


