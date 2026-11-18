Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023910;
	b=ye0EKl725OuNXckspzcdO5G9gbdCyjiYaOk3W66xsdPBK8Bxirmc3cJRkN7EpwKnGbh+
	 G0fRBttqZ/WUrvZmBXqNeIE1fsl1YsqBRjRH1IHLTMv4U8p4K142fVNtNRvBbEeCRotUW
	 xbwId58ssbE3DU8JTXgxBUtGvxMy5+DY79+FA4JPmJ2YukfWB01L4xScVEx8HafCscIPM
	 tKoxfHBh4m/qNOLuAJsmsOlFWRvKoe8iitO5RwsmJhlf839RDFqz5Up1NFFj0atnEtjx/
	 vIgcyFLyOQIlTsspAItI8oEGJU8HCILTXWigTwVNxpVCCu1GUnRr+9FHOIcQpAUkvUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UaLtWiS83ObET7gGKkEvATgSKdxdP8JZB9GAavXm/H0=;
	b=dNWeUmkPkDKJzSU5IeRk+DN/GYpVkp5m9fjneBDG6S6grrS9DMU78eoUudr0brf0Tmir
	 fjI8W+h1/QfneHk866oMpxtwML9/n3VWKBnJHOsyAbDSzydq93MUlIDvzwdisKu0leLxz
	 EE0F8qXUhehW5oMSyqMBRAB6YxISogQ8ubeG6aHTIyVabOW6U3wBjBSplTgjE6mEc1yoS
	 mahhLe87wbxkCV2Ru7hF9TGPsqUJZQ5ICoKLiq8ls9KdaJIXuim0nbHgYJKtOa9dZ+8y0
	 Ot25bEBYvxX3Zn9yREZouRDRMjsnf7aOzqHErJ6DVMN7Fx/ZZwTj1YPB4DJEOdHi87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DxxSNVK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38993606A330;
	Wed, 18 Nov 2026 17:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1DxxSNVK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DF1F000C4;
	Wed, 18 Nov 2026 17:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023910;
	bh=UaLtWiS83ObET7gGKkEvATgSKdxdP8JZB9GAavXm/H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DxxSNVK3kCcgZQ65HSqcUbRgL9e33EkmTbNB1poGJSjQ3Npsc02SMA49XkGoJrHL
	 zTDJJYNQIaOajuv1/yDmCCgg74jzVUZDl4bpVb0wsCAk6cTW7Ly+K1v0Nh/J2X5KgE
	 LJJ4SJeaoR9IKzNKlxSA0KmJOk7OqVvHgYaE+22I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0537/2151] ACPI: HMAT: preserve hmat_adist_nb notifier block
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150141.567312642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 11e4483685c9c..a63af4efa0e18 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -994,7 +994,7 @@ static int hmat_calculate_adistance(struct notifier_block *self,
 	return NOTIFY_STOP;
 }
 
-static struct notifier_block hmat_adist_nb __meminitdata = {
+static struct notifier_block hmat_adist_nb = {
 	.notifier_call = hmat_calculate_adistance,
 	.priority = 100,
 };
-- 
2.53.0



