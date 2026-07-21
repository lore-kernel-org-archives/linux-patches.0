Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE4336888;
	Tue, 21 Jul 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654991; cv=none; b=dmARJAN3IyhMnaNKaUFpWQBas2M039zClLXN+Yk4Wyz4kV33PwhbUOK5zpf13My+hVYKPL+40BfZQMpfy4ajqvjrlY19IoRNCMj7yQcjuBRuCWcTnmIbHiecT5SQmVQLMLsdFckEFvullZ/83USwfEPBd8dj9+f4IFv/79QO2TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654991; c=relaxed/simple;
	bh=9kJ4NPKISq7cJv14V0iKUfA8jiq0ick10kV7ycnnTmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8r4UTvd/tWZhzAVreS5LfdYCSKPRy7IGrlq+G+4z1e5WJV7wK0HkMBfi8WVpjIaCZOh/wbm+FM0rkLa8o6VgIbNj0bIbOo/RGTIsnarmkn1n7w7WsIjEuDwyKCif9Q+TTh3tDpzfVN8j0nftIYQCctdNmXb50w+p0AqioA6fek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otiK/fzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otiK/fzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1645E1F000E9;
	Tue, 21 Jul 2026 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654989;
	bh=EuLtJOqyz5RxPk8bbhP5bo6pqZKktzU7ZTg+QaCsrho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otiK/fzCduo5HJTA6Rq9fnr/S3ysZ1p3GaynCKu/eNNrJFhtobURy8xYw+C/Bxhpr
	 LRXjpPfcOrJMmd1jZTDNXls7vhIjKhxGlSsgtP4zQyapA09xukOJ46hE5bEGlwrUTp
	 VXQqtt3+qjWnaEX+UZGEsSNj9yjE9S8PBLc/T4HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edoardo Canepa <edoardo.canepa@canonical.com>,
	Ross Porter <ross.porter@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1914/2077] selftests: net: fix file owner for broadcast_ether_dst test
Date: Tue, 21 Jul 2026 17:26:27 +0200
Message-ID: <20260721152637.862288795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Porter <ross.porter@canonical.com>

commit b8613e9792002add3bf77122868cc06ce142e953 upstream.

Ensure the output file is always owned by root (even if tcpdump was
compiled with `--with-user`), by passing the `-Z root` argument when
invoking it.

Cc: stable@vger.kernel.org
Reported-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/2129815
Fixes: bf59028ea8d4 ("selftests: net: add test for destination in broadcast packets")
Suggested-by: Edoardo Canepa <edoardo.canepa@canonical.com>
Tested-by: Ross Porter <ross.porter@canonical.com>
Signed-off-by: Ross Porter <ross.porter@canonical.com>
Link: https://patch.msgid.link/20260617061039.79717-2-ross.porter@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/broadcast_ether_dst.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/broadcast_ether_dst.sh b/tools/testing/selftests/net/broadcast_ether_dst.sh
index 334a7eca8a80..cc571f607429 100755
--- a/tools/testing/selftests/net/broadcast_ether_dst.sh
+++ b/tools/testing/selftests/net/broadcast_ether_dst.sh
@@ -44,7 +44,7 @@ test_broadcast_ether_dst() {
 	# tcpdump will exit after receiving a single packet
 	# timeout will kill tcpdump if it is still running after 2s
 	timeout 2s ip netns exec "${CLIENT_NS}" \
-		tcpdump -i link0 -c 1 -w "${CAPFILE}" icmp &> "${OUTPUT}" &
+		tcpdump -i link0 -c 1 -w "${CAPFILE}" -Z root icmp &> "${OUTPUT}" &
 	pid=$!
 	slowwait 1 grep -qs "listening" "${OUTPUT}"
 
-- 
2.55.0



