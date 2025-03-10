Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3E122FF42;
	Mon, 10 Mar 2025 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630554; cv=none; b=c/zBBeUi4wKiLmp7XETTyTP9ChM8SSmxdW6uFXTfMM6QGstE1FfIUWaJLk0uZarVf0EQgtvILFXsBiTI4+NPNm8QsENYMaebGFhTsL3XsIUe1gYfW8VMLxPHzGXR5JTdopxMuNGEBsutMkUOlCE2C39br96NaCg4wi3frqUTy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630554; c=relaxed/simple;
	bh=SETvTJBcuq8DLkoh8hlktB8NZsEmPafpGKCEUDDpTDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWLMiZgx1DUPt18+4KxTHpkipLp7KnbPMUn0tFIzEm6o1zJnZK1yxb30IxyBNoqDDAw7eMhWoSXh0N1OVUX3QNkTGoGRkWNu+/PSKoTpSY2iCcVaTIyii8zeqcshzu4nEZuIf9WFfUxjXXAe/aN42TQsMx1SMTr1VGDSFK3b0D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+qNvJvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+qNvJvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D671EC4CEED;
	Mon, 10 Mar 2025 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630554;
	bh=SETvTJBcuq8DLkoh8hlktB8NZsEmPafpGKCEUDDpTDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+qNvJvfog3bVa5PYWvH0CcMAQEfoNccyg5lMmk7EYD80EvGtAfN7U610AxcKyxuG
	 fDhDIdR6qE9+YChEh9i4yO9r27TReDPi45U1OBTJEP9piuMolnelLPAgKyp6mj562o
	 VA2yZ5Rlxbz2a0roGpv21oZoUAHNOd+WhrXJ6nMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 423/620] selftests: rtnetlink: update netdevsim ipsec output format
Date: Mon, 10 Mar 2025 18:04:29 +0100
Message-ID: <20250310170602.287872646@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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


