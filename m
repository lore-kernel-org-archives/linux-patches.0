Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1054C145359;
	Thu, 13 Jun 2024 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280409; cv=none; b=ttMsWfsTrC+5iS56iZ/SV+2930KKpovJOseXuTMgdDUs6pdYWp37vz+lCBZp5VfVmslgLQa0FOTdFVKlj1mTMgXZZJSbzEnXJl0KqcwphgjnbldOXTfnCEKaMJhKFVf0mOREaB/hA32vBtbqc9pa/8cnzFHKTVwb8d0Uhu+rjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280409; c=relaxed/simple;
	bh=zaVTKQ9HnU7I7WY4Wy5Bi25kYb8rf1XJMYl2x9NrafQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx5xAJD16F2cGg4LpAavDa8VZfhxEXmjqmcL+qyEIFMg7Ja+2we+SmEHii4kJe+DFF4ZF+rG9YOCq+tWhY+LJzu2h0iP6Jcw3qeUhP7RX0sFHS6gO+ZbYnqYmAi5oArhOFWjsqGS4M6s499dGS4IVbofYwEZAp1YoxGrfra7GuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5Z9AXAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5Z9AXAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFF2C2BBFC;
	Thu, 13 Jun 2024 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280408;
	bh=zaVTKQ9HnU7I7WY4Wy5Bi25kYb8rf1XJMYl2x9NrafQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5Z9AXARApmwQFJ3ai7sw7Jb3658ORjW+SzIzeYdCEYA89/vuq7a0sP1SAgfOoZ3w
	 nbfsV+ARl7yX1kftbSPB6lrF2BsBm9dM2pp0rWLKeSXAUoktF8EUIDjBT9ftwnnbmk
	 zGT9UPpyY5pvz4OzPVk3uW7sw7tczjClfHTFQ/lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 013/137] selftests: net: included needed helper in the install targets
Date: Thu, 13 Jun 2024 13:33:13 +0200
Message-ID: <20240613113223.806048932@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit f5173fe3e13b2cbd25d0d73f40acd923d75add55 upstream.

The blamed commit below introduce a dependency in some net self-tests
towards a newly introduce helper script.

Such script is currently not included into the TEST_PROGS_EXTENDED list
and thus is not installed, causing failure for the relevant tests when
executed from the install dir.

Fix the issue updating the install targets.

Fixes: 3bdd9fd29cb0 ("selftests/net: synchronize udpgro tests' tx and rx connection")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/076e8758e21ff2061cc9f81640e7858df775f0a9.1706131762.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[PHLin: ignore the non-existing lib.sh]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -55,6 +55,7 @@ TEST_PROGS += rps_default_mask.sh
 TEST_PROGS += big_tcp.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
+TEST_PROGS_EXTENDED += net_helper.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite


