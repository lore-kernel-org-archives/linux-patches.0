Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049591;
	b=2Xh//g9dsGQFyWVsFi2IikqWkRxrrsGxXeiT/+QmzQu2Pzb0mkVzwSPCC77iZ/XFRunH
	 l49M6Zptf0+d4MnX0CZn4EZ91o7hKM1ZpFdV3G9VY6tyQi1tCwR4o8x/0cNo5iFzQJQUp
	 EyIrZS/UwwGCIvVRtrX16Dp1M21WuW4hi36No9Vvo7fnezXi9LbXpOnUDSN8PEX4t7Tv2
	 CPtl4KsDG8Q7HDK6ujl/Afn8gHDqFJcqA9d96t/1COAzCOhTDunnBdZl+y1PvGB4N8eoo
	 HH01RlPsijGyb8rad2/H1RKi7kg2w733o0724118V5XcF8jKxsqMHvlpeLgKJ/uE6bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUJgA+vxYSEG+4/L9TGFYFayrn1H0qDN8+EY6cKege8=;
	b=agw4tKlb5srh1eaIBj889kpU31FnWW0kX2vxANDngk87vuCB/U0DCV8QjYCVHVXDrzSF
	 UGq0Ry8Jn8ZfJ5hBJioJi7XvtcEsXch2233ug96lt0YtDsAFKoPWWYyi69ErPOYr6Hjr+
	 eIEhotqz0ojAVPaLU8dzpSeX+F4Joz2xgVymMlW1W+EAcgf2guy+SFyZEl7aVonitUo4H
	 5uVszrSdjF8mxXc5QdWqWd9EueFVw+ZRtoAJmjG9PgiUHog1zg3xandHwtm+x760xK4J/
	 +qNSoFLvSZGvRIRIyFNgz2oT7N4vREzf5Y5p1A7lKxQLEQxp3NSGvIJ99guzyTctRCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrcH09AR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B0606A31C;
	Thu, 19 Nov 2026 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vrcH09AR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3F91F000C4;
	Thu, 19 Nov 2026 00:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049591;
	bh=JUJgA+vxYSEG+4/L9TGFYFayrn1H0qDN8+EY6cKege8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrcH09AR8KgYZX8ZS5031BY9VqY+XB0EzYjhvK6TDi1UgqilRI88ZB1XhrlnxwN2O
	 W12GhUfZrLj2phpty6Yfks1GtBFPu9lW6qEeE6bbKKx5fCq/R7P0AlBoG1DPk9MSwv
	 dNd+lBzMGw9odi0B4K2WruUUddYtGFMj7hh8KIh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2365/2857] ACPI: PCI: pci_link: clear driver_data before free
Date: Wed, 18 Nov 2026 15:56:39 +0100
Message-ID: <20261118150326.672669253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 691c33289b4d7a50b6fe1e03918bfbc21d4641c5 ]

acpi_pci_link_remove() frees the link object without clearing the ACPI
device's driver_data pointer. The ACPI device survives hot-removal and
can later be retrieved by acpi_fetch_acpi_dev(), leaving callers with a
dangling pointer.

Clear driver_data before freeing the link.

Fixes: db89b4f0dbab ("ACPI: catch calls of acpi_driver_data on pointer of wrong type")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260925155846.2381956-1-yaojiale02@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index aa1038b8aec4a..b53d44bc523b8 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -778,6 +778,7 @@ static void acpi_pci_link_remove(struct acpi_device *device)
 	list_del(&link->list);
 	mutex_unlock(&acpi_link_lock);
 
+	device->driver_data = NULL;
 	kfree(link);
 }
 
-- 
2.53.0



