Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92A11CAA95;
	Wed, 19 Feb 2025 08:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955375; cv=none; b=NRmx7EW/DemkS7/JkoHW6fcMEGVB1MIWwyRSXfJaSdUsNRGUOoYZPHnBFjx0T0Biw8QuWiET16n8iC5YysBRhAatfkF0jwLi7GYu62LxVTtSYGibIrj5kuB1NUZIZS5jnf0HkzwVWwevU2eWabjHsixG5mU3bHStA3tLtAe5rX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955375; c=relaxed/simple;
	bh=RBSfkB6CHPYNxlA11w3kw8hyom8NEiuU+UwKFEySKpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD4wEYwU5yf30NKWaooISOe+x7o3hZgQ1zB5l2wGTP4As2GnScd8DaoQObilw1joM2R60HXkIUnMQ0grW5AOQsTvsB1MqEe6kxyD2P833mA21k7Q3owD+VjQ0eEvTZXAxSQkRJtE9+/OaJdDVjZ+CEPk0bk/JfY+gyQHZkBB2dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFWgYZLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFWgYZLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079B1C4CED1;
	Wed, 19 Feb 2025 08:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955375;
	bh=RBSfkB6CHPYNxlA11w3kw8hyom8NEiuU+UwKFEySKpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFWgYZLzw+wN/xPJ8ASA6xDJL9Ra0ESfoBrhE2ApL+1iHqm0/3uHKCbp+xPflXI0t
	 akOh8b86vF0RhhVXKCyoWvYHG+iYImyYpQ9aff86nQfkM+4RfY6S6J8x2zJtdpBgXj
	 07lmedWcV4HS9MUL6BPMvk7qjyzCjNorwfOEwRWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 216/230] selftests: rtnetlink: update netdevsim ipsec output format
Date: Wed, 19 Feb 2025 09:28:53 +0100
Message-ID: <20250219082610.143688554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

commit 3ec920bb978ccdc68a7dfb304d303d598d038cb1 upstream.

After the netdevsim update to use human-readable IP address formats for
IPsec, we can now use the source and destination IPs directly in testing.
Here is the result:
  # ./rtnetlink.sh -t kci_test_ipsec_offload
  PASS: ipsec_offload

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20241010040027.21440-4-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/rtnetlink.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -809,10 +809,10 @@ kci_test_ipsec_offload()
 	# does driver have correct offload info
 	run_cmd diff $sysfsf - << EOF
 SA count=2 tx=3
-sa[0] tx ipaddr=0x00000000 00000000 00000000 00000000
+sa[0] tx ipaddr=$dstip
 sa[0]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
 sa[0]    key=0x34333231 38373635 32313039 36353433
-sa[1] rx ipaddr=0x00000000 00000000 00000000 037ba8c0
+sa[1] rx ipaddr=$srcip
 sa[1]    spi=0x00000009 proto=0x32 salt=0x61626364 crypt=1
 sa[1]    key=0x34333231 38373635 32313039 36353433
 EOF


