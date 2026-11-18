Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039910;
	b=qqipcT4CmAdiD665NnDbCYCnj8ixVPE29iWzxoZ/zGBt04nVd2aLdtWXCYCLeXt6+P6l
	 kwraTtaZopVFqjf31O9TbzFdvo8+SBsguGVeL05jkrVqSnh8jPN4DqjXx0oxTlEPPS9tP
	 igss6ygH1usbaDx5xgAS/8KSRKoUu47btJIwSlMLaSr4g+FCJ8SeWkI77HWPK4XIcev/2
	 mW1z2NqmVXiV7DsI2WjyohLMx9vMTJxCWiTWch6fRZXB0rrqkm4MXi8qbIixhAP7mmqxf
	 5zYCn1ehZ6VQnlRaOhUdmfxTptjpgQdEEobGQ/1V0qYszdiRlCoH3vHrHEB3EM5iGjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHn1hXHOpzbHPHRjbUrlRTnUCdWj+Not+lv3+/dpa7I=;
	b=0IDrzCnPWvOsBYZR+qvY6H7pFrAA0ygl1BirUqvqxPDQTf4M0FNlm2ZnQhjPAxXYHQRB
	 EzavaX/0SxJT8BXaZdhSN9QxXDK7KnihidcktE/8KfeDoI2rAJBduk4KCPxxU+E3/16f1
	 Az7HD+hWDdU6haYtElRkypaVZDUAoVWyIiObPQsI2KvOYqn0n/eS+gIa67eygGsRaz9ad
	 BIdYvaGp2wSfnccKG9tPXMBL2qpzRDl+XOWE+miHjBai3kEGBEdH9eB8Kuy1+xX7aBbgr
	 ThJ9U+R/wVIcdC1S+dnFXfjhn1O0WQPAPAwBkMhz7zESGaKMgDssLtpfU6iUW6aPleA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bndy1IhS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC5D606A31C;
	Wed, 18 Nov 2026 22:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bndy1IhS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF4E1F000C4;
	Wed, 18 Nov 2026 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039909;
	bh=BHn1hXHOpzbHPHRjbUrlRTnUCdWj+Not+lv3+/dpa7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bndy1IhS4B4Ajo9vv34WYbHi74Vj/wf09R5UU3RUtbJGCSFAk89W8guv6csd0KVhj
	 WiF9SkSfxF86m163h7u83Lgaz0ZsxL3NJLqIDct84Ja/41cMtbsur3Ie1I4qAHJx82
	 rDqpfirCqA7uv8V2XCqP1xhrjWwwp8LH2Y98xE2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2267/3318] ACPI: HMAT: preserve hmat_adist_nb notifier block
Date: Wed, 18 Nov 2026 15:48:09 +0100
Message-ID: <20261118150429.816354873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alejandro Lucero <alucerop@amd.com>

[ Upstream commit b1c75a77d494298b8dedf46062f2072239bbc33b ]

Remove __meminitdata from hmat_adist_nb declaration preserving it even
when CONFIG_MEMORY_HOTPLUG is not set. Otherwise further notifier
registrations using register_mt_adistance_algorithm() will find a
notifier chain likely corrupted.

This is the case when cxl_region_probe() calls
register_mt_adistance_algorithm() what can happen when CXL regions
are dynamically created at any time from Type3 device(s) or when a Type2
device is initialized at its driver probe.

Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260716181114.35962-2-alejandro.lucero-palau@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/hmat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 1d6450c139225..78ff99d29e41d 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -903,7 +903,7 @@ static int hmat_calculate_adistance(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
-static struct notifier_block hmat_adist_nb __meminitdata = {
+static struct notifier_block hmat_adist_nb = {
 	.notifier_call = hmat_calculate_adistance,
 	.priority = 100,
 };
-- 
2.53.0



