Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64545340D9D;
	Sat, 12 Sep 2026 10:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207704; cv=none; b=VOB4c4qMcBldKHgVTKszXitxdnwZc0xw9GnwvpoyRNfo1g+HPJnf0UwTbfVqYTfAteNxStFHxiYD8hQJ546jMqDyLrq++uLyrloeRYtRI6hBtS59XgwW4QHucPPzWexBFfHYAUWhHAkpcMscbVPjPQnRqFH7EWiL+4+HExaKtw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207704; c=relaxed/simple;
	bh=LB8YVfmLI2u2xklvd4XwONPmxDb/h176hcsNRvARo/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVqcTFiVbDQTLDBSfukpaXUGw5j7DMS8Is7/8z40+tgFLz8C8rda8TereWt7xsF30fuo9j8Omk5LVP3sMTxQi7tGQNBcYmB+v7c0HYyP1DSxIU+Dgz9vveqaAmV/tDHGX+Xlxr6enSvpqxRx/QRk0DhV+Bsfg0PSPWjJGBhlWyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UsfbQ/WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UsfbQ/WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C5D1F000FF;
	Sat, 12 Sep 2026 10:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207703;
	bh=oP+d143pDAbgwVHHnFpaXJ+0oJ8rWSQCw6FhOjwymCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsfbQ/WCImOyDuSzEaHVUT2RbmSsKuZushRlhA5O1s9R85UY11X8T5h8u4LfC6ufW
	 /j2NK8qZ9HRbnMs39NQ9rzSbVs29H65peh4PYAd9Yhh/VYow4fq0D12yO0KkA+VzGR
	 zVFx3oAy9Jw1OCdDvrWjyeR5tRLRAv0ZNC8YyW2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0468/1518] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:43:57 +0200
Message-ID: <20260912065634.035491754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit ba3dedcf3bd47017307595a7e54924198f018246 ]

The bounds check for the index passed to
software_node_get_reference_args() was failing when passed UINT_MAX,
this in turn would lead to an out of bound access in the property
array. Fix the bound check to also cover the UINT_MAX case.

Fixes: 31e4e12e0e960 ("software node: Correct a OOB check in software_node_get_reference_args()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/20260611103904.7CB131F00893@smtp.kernel.org/
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20260611164005.2930205-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index be1e9e61a7bf4..1e08492935eeb 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -529,7 +529,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



