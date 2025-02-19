Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DD21CEAC3;
	Wed, 19 Feb 2025 09:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957578; cv=none; b=eLTNSrWljyeKlBpEB/ob1twEfD6/XNKAqgkuVCAxjytf3jqmjQPdJclycBpSUmM3L2JEtCZi7ChHdQrH5KdB4S2JK56WkOLgdDehWuBCG9IcbvpEUcbO2CLHGkQVsrh/CNT/An3ZaNEc/WX06H2qR+w8+ahJBdtjIPTGRL6WF30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957578; c=relaxed/simple;
	bh=U2qI410TPLk6uPu0B6f18/gOQotq5Sz4KkkaEfMRzek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFXoQV+HloWYoSSsDCZWkmRTdoQDZoLf/BohHpATKZngVbJ5t04kBP4LekbQvFn22WYnmkLDdq8yxLQq5E6bGp8gYxOWz5bvTEcNfz99k1hLIMobeoFPnEcABwbgdSimNQUwuowDnSA30I7KGLBuGJWc5ZMN2e5UejH7WwDVcJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnEo5CXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnEo5CXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E13C4CED1;
	Wed, 19 Feb 2025 09:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957578;
	bh=U2qI410TPLk6uPu0B6f18/gOQotq5Sz4KkkaEfMRzek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnEo5CXK50a/NvHnUhrV8WcGYUWv+al3C25XVgcd2pw2QVvU++lbBw9AGQDMPXcjF
	 w94P8cxw6NYym/pxFYpRFuWnuFv9KSOKWuRFAx54T8BZ7zJi2QN2TuLwcWnMYtAlWj
	 PU0M0rEofUBYWmmBY+2k9tI9iSr01PdEQmMWlc28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.1 574/578] selftests: rtnetlink: update netdevsim ipsec output format
Date: Wed, 19 Feb 2025 09:29:38 +0100
Message-ID: <20250219082715.532432227@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -813,10 +813,10 @@ kci_test_ipsec_offload()
 	# does driver have correct offload info
 	diff $sysfsf - << EOF
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


