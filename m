Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0ED1C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01489C433D2;
	Mon, 20 Mar 2023 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326126;
	bh=jiYlifzQ/nQU/22g0bAxSe9qhgfWxDJRdMiz0zNYx50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmrDXaG7MYweM6Qw9oYJJIhZ6Mo8Ner/5fzN5Y+BGN30v/6Dc2AO2hlgaLSTHsoYH
	 R867I0P1Y4qmQy7vzZixKBziwwiVhasKU2CjhQI9bNeXvwDNTh54cRNWSzdiSWcbos
	 N3VgT/9FfybRQcAb6a0uP9wmsmWoolS2d6WYIMv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.2 142/211] md: select BLOCK_LEGACY_AUTOLOAD
Date: Mon, 20 Mar 2023 15:54:37 +0100
Message-Id: <20230320145519.387946584@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: NeilBrown <neilb@suse.de>

commit 6c0f5898836c05c6d850a750ed7940ba29e4e6c5 upstream.

When BLOCK_LEGACY_AUTOLOAD is not enable, mdadm is not able to
activate new arrays unless "CREATE names=yes" appears in
mdadm.conf

As this is a regression we need to always enable BLOCK_LEGACY_AUTOLOAD
for when MD is selected - at least until mdadm is updated and the
updates widely available.

Cc: stable@vger.kernel.org # v5.18+
Fixes: fbdee71bb5d8 ("block: deprecate autoloading based on dev_t")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -16,6 +16,10 @@ if MD
 config BLK_DEV_MD
 	tristate "RAID support"
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
+	# BLOCK_LEGACY_AUTOLOAD requirement should be removed
+	# after relevant mdadm enhancements - to make "names=yes"
+	# the default - are widely available.
+	select BLOCK_LEGACY_AUTOLOAD
 	help
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one


