Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4D1F540C;
	Tue, 21 Jan 2025 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482832; cv=none; b=K48KeCmzuG4qLY3mZbhO8WZgRXGmc/dxISpZyApCjuS553o54hnFMZ6UVLADUzNE9alnid3y1tnZLhCdCJwvT6xL5KgzRk99USNQeXHwgFC2tTMcuORlAP8ZZmxdzNoG/4vX8Y/tQtxQKOdidHYZ4vMiFuMpMJ+i9CFRwnHF/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482832; c=relaxed/simple;
	bh=15J8YgPm72FqcABBHTeYW/KHj/SOD+rSF0mKtC72ZFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djXg/NOfg7JO/d5qIiy8ml12xH1VoadN2/EaeWkNbSzHojfSLdTF1mow8Oixv2oXzlfwGPC9+XTBTZi+tzWyZOq4WGi34tAeLfHwytkoCmhRiA3Tf4Aild3AUqJRMk82xPbuKuCO0wdAUV89usimwJb9kLAoTzca5PSYNCQKyu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOEmt8qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOEmt8qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD4FC4CEDF;
	Tue, 21 Jan 2025 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482832;
	bh=15J8YgPm72FqcABBHTeYW/KHj/SOD+rSF0mKtC72ZFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOEmt8qxAHnkEYABuxGCKEE629JYReE2s+qSuXBY+aZRb+kwOTeCutQSw6XJUewkE
	 YcZDPzgGJu15HxxDNMpG6dB7OZZpdnlRk5U+BHb8iT5ISwOEyyIGqfaU3toDBpaWio
	 eaccGkzUof3te4eDbBdtEJc6B871PBXAGjt8421k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 023/127] dm-ebs: dont set the flag DM_TARGET_PASSES_INTEGRITY
Date: Tue, 21 Jan 2025 18:51:35 +0100
Message-ID: <20250121174530.568697795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 47f33c27fc9565fb0bc7dfb76be08d445cd3d236 upstream.

dm-ebs uses dm-bufio to process requests that are not aligned on logical
sector size. dm-bufio doesn't support passing integrity data (and it is
unclear how should it do it), so we shouldn't set the
DM_TARGET_PASSES_INTEGRITY flag.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: d3c7b35c20d6 ("dm: add emulated block size target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -440,7 +440,7 @@ static int ebs_iterate_devices(struct dm
 static struct target_type ebs_target = {
 	.name		 = "ebs",
 	.version	 = {1, 0, 1},
-	.features	 = DM_TARGET_PASSES_INTEGRITY,
+	.features	 = 0,
 	.module		 = THIS_MODULE,
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,


