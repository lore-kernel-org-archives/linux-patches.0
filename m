Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0375F145359;
	Thu, 13 Jun 2024 12:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280412; cv=none; b=qXvcSIJyVJcwAqqNPvnleKqSH5Z2GYlvcutQsrcn7tPmyJyVYEP25IEZwn9FxX6hoZqPGs339kh11eZWhysGZKuMVu06nt+4ONtJE04OBmaH9MUsHL+BeBZxUKvh+cGawik+thNf7uJPzaFMZt+hctKN5qtXAfieZXiKi3uJ604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280412; c=relaxed/simple;
	bh=TwN/TWIES48+YXv5/VV6ruNQRhx8zEP2dwmitafp7cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifLc3kJbfWGbocMBNj+xlj5e9nzTLdhVBhuVZnnyhaIbEBLIdMmEyW5SsZ69lIybDXtJRBxRFaTD8pKvHBCn8BXWBq2NjI30aHqojUd5Ac+LEo2Zp/TC/wm8oUXqQZ6oWebBgTjLcikuRegGjW+ueZtHhfR3nnZvjx50fT9PJJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TucVT8N1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TucVT8N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E541C2BBFC;
	Thu, 13 Jun 2024 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280411;
	bh=TwN/TWIES48+YXv5/VV6ruNQRhx8zEP2dwmitafp7cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TucVT8N1QjQD7d8DKBR+NDTVlFOe+GfRzMarALLSFhOXhKQX1B1DPku/ibVB5aSzC
	 DJJ9kHvYZ4g+DjbxTDIUgmOhBj0hxiXpAuXFxUEn3fPePNAFCz5b9HXYRDEsJjWVha
	 kYGR5/u3EPG/uOfsNZpvLFdohYxbLA7xfkV2V1Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 014/137] selftests: net: List helper scripts in TEST_FILES Makefile variable
Date: Thu, 13 Jun 2024 13:33:14 +0200
Message-ID: <20240613113223.843530476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

From: Benjamin Poirier <bpoirier@nvidia.com>

commit 06efafd8608dac0c3a480539acc66ee41d2fb430 upstream.

Some scripts are not tests themselves; they contain utility functions used
by other tests. According to Documentation/dev-tools/kselftest.rst, such
files should be listed in TEST_FILES. Move those utility scripts to
TEST_FILES.

Fixes: 1751eb42ddb5 ("selftests: net: use TEST_PROGS_EXTENDED")
Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Fixes: b99ac1841147 ("kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile")
Fixes: f5173fe3e13b ("selftests: net: included needed helper in the install targets")
Suggested-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Link: https://lore.kernel.org/r/20240131140848.360618-5-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[PHLin: ignore the non-existing lib.sh]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -53,9 +53,7 @@ TEST_PROGS += bind_bhash.sh
 TEST_PROGS += ip_local_port_range.sh
 TEST_PROGS += rps_default_mask.sh
 TEST_PROGS += big_tcp.sh
-TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
-TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
-TEST_PROGS_EXTENDED += net_helper.sh
+TEST_PROGS_EXTENDED := toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
@@ -94,6 +92,7 @@ TEST_PROGS += test_vxlan_nolocalbypass.s
 TEST_PROGS += test_bridge_backup_port.sh
 
 TEST_FILES := settings
+TEST_FILES += in_netns.sh net_helper.sh setup_loopback.sh setup_veth.sh
 
 include ../lib.mk
 


