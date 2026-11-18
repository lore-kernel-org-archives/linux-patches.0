Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015372;
	b=HINR0hF4lB5rUw9HpGoF/m2iUm/N+IZJ8ch37n2ObElVK7SkPU86jZ/QK0hTdZKtg0kH
	 VSHtCV66u1HLOflyAgsP5FVnWl2X0UuY4HydNh1Ubte9pHohbe6wSdfmxm3TYEziH6roo
	 nAxlDrGrLb4HEQdZBkawfbPT8z/QU42aOl8tZsT4mQq5pD9AUVfMYBePhzCjexRp1SJr1
	 zKgNvRKebgrA5rg3Xq3K7YRqvo3UxklgR/eQm0cr7Nj2wm7P+8/39ySntNT4+MFTaJon2
	 /H3PZfDH5vXmgC0tjzZVcChMtBYUxoTnRg5fjGW2FOOYPFYZZiKLPu+kHJQh6TQ8A2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N7Kmr3YQD04pNlWBcUiOTnra+pzfXapBMh4/M/WR+vs=;
	b=qcTBylwBQABz65tVJxA5hXPJMoE1oY/x0ZfM2wo8Z9VgOGFO1nclb3N4LpAOO919Fdbu
	 FA6bwozc1Qw7WJn5Rmn0x5YwXSgO6xgBmiaXm3iAUSAaGmCd2duFhBK8gY/h4MRQNXvpl
	 SZs9M+Ub7eQJdJCXwMQMqnWCC0X6kEdVPBbzEqni2BuSJm9E1pR2ioGlnImk1RVGTQ8FW
	 CXsOYwYzE9NyNPEQgPFpli5oEmkMifeg3H8/pK50sU7OxrlNlNJNtoQ+H+Wxd63UFH5ce
	 VeI9EBNgZZAxi+p06vxdzGd90y0hZ4bij33rhocHb+/Dv0jhvn0Yf2tww1H+x0rkUxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2IhPBme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEDB606A32F;
	Wed, 18 Nov 2026 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2IhPBme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B011F000C4;
	Wed, 18 Nov 2026 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015372;
	bh=N7Kmr3YQD04pNlWBcUiOTnra+pzfXapBMh4/M/WR+vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2IhPBmekHvlsLGYF116uBDdK1Pqj2Sdu3JbMG4agvlA+zDJMl0EYM23hvNLOGm8o
	 VJiuxSIzAht5tak81ZKEO0cdNAO/a5SmD8Fi1bpnyWhXWVxzM+bw9jqJQh730p+tOi
	 1PFADyCgV89yEso+Q6oxisY2UZX6lZIGhOYx1BkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Faure <boris@fau.re>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0149/2651] soundwire: intel: initialise quirk_mask before reading it
Date: Wed, 18 Nov 2026 15:23:09 +0100
Message-ID: <20261118150253.221965282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Boris Faure <boris@fau.re>

[ Upstream commit ee8a8cfe4e8d3c67456e554c988017c252710a25 ]

sdw_master_read_intel_prop() declares quirk_mask without an initialiser
and ignores the return value of fwnode_property_read_u32(). When a BIOS
does not describe "intel-quirk-mask" for a link, the property read leaves
the variable untouched and stack garbage decides whether
SDW_INTEL_QUIRK_MASK_BUS_DISABLE is honoured, so the link may be marked
hw_disabled at random.

Initialise it to 0, matching is_link_enabled() in
sound/hda/core/intel-sdw-acpi.c.
Found by code inspection, not observed at run time.

Fixes: 395713d8ca43 ("soundwire: intel: handle disabled links")
Signed-off-by: Boris Faure <boris@fau.re>
Link: https://patch.msgid.link/20260820212220.226912-1-boris@fau.re
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel_auxdevice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index a8407560bf4fd..9b1465af26458 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -159,7 +159,7 @@ static int sdw_master_read_intel_prop(struct sdw_bus *bus)
 	struct sdw_intel_prop *intel_prop;
 	struct fwnode_handle *link;
 	char name[32];
-	u32 quirk_mask;
+	u32 quirk_mask = 0;
 
 	/* Find master handle */
 	snprintf(name, sizeof(name),
-- 
2.53.0



