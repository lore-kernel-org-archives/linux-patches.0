Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E11AF0C0;
	Wed, 19 Feb 2025 09:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955922; cv=none; b=qLa08G5Y7lvJPwp/einVZHRbYw1/QSZ+J7ntd+PDWJ9AexNCm1RmT/MhhrKaNNZoHyCRVn9SrFUxbnwcnAWehbj23+902kAMSniUmR3h1DezFfi2aDWfqWBAGv5ugQwOZ7WC4LnTzGId9bhVv/wRddDGqvqWd15B3NBE8ITg0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955922; c=relaxed/simple;
	bh=ofOhhP7V3swjuMtObQ2JyIRkLZbEzKLpDdkUp9OauPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRw3V4LNpeCvPtv8K2qT5eu1sKxLqDBDD1lt6nCzkR3TK1YW4zftji3q89yzm1p+PC9OpuSamifYwjhWvRPx4IhNZPQscnK+rMur5smdW4guPpX3EXKLcKNStIbCt7ewbIyWyfTabPH2i0LpaDCPegwQWV+YP0Qd7OVhz48o7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flu3oj2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flu3oj2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49580C4CED1;
	Wed, 19 Feb 2025 09:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955922;
	bh=ofOhhP7V3swjuMtObQ2JyIRkLZbEzKLpDdkUp9OauPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Flu3oj2+6ckFb8qp1a725xCYxQtvcw4L8KbJlMrSmWwjQhvRnzpWLW7PR+10zSIoQ
	 sGCUJQM3gFKurIiSG2tLqwBtlIueB+9WAarrFR/arABYYY59MWe4i2oEDRrUBQrlfd
	 FTf+itz6O2IJ7zE/Rrf9ktPPWU9MXkGhkldypHkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.6 137/152] selftests: rtnetlink: update netdevsim ipsec output format
Date: Wed, 19 Feb 2025 09:29:10 +0100
Message-ID: <20250219082555.463082096@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -921,10 +921,10 @@ kci_test_ipsec_offload()
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


