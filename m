Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17135307ACE;
	Mon,  1 Dec 2025 11:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588616; cv=none; b=Wdu/1SgqE5AKhTJFTNDxCITinykhZjW+d/vFYsnLZRbF3nIMO3tGSNfwl+c2Qclp240NqIcuTGUiZvJPQDNhCzIAM+8pJU9GHWyxb4Mq0mR9wuBTvq97vFkj9pvlrXyC1No1nCsaeMkt9jqQa2MapKPI3CDJFprLJgei5q5i/d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588616; c=relaxed/simple;
	bh=OzJxtv1/1oe5X1T/LzfIE7+NdW+2BKCV94cb7oKxBPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKzk7Vf93ouzTbYzrn+hCqWhNztUpxUD2SVxT2i0u5l1KqL2eaMmVkirtW9A3mQ5mJzy18SihqZbv8Rnrzunl2YS6izDE/Xy/uTPBl8zr+NZ81PUnCLWQIVXIUr7/nHG/MInOAXghTYZt/pjn+ytTafDFzQB6o1ocbt6OE/oDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyaNesti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyaNesti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935B5C4CEF1;
	Mon,  1 Dec 2025 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588616;
	bh=OzJxtv1/1oe5X1T/LzfIE7+NdW+2BKCV94cb7oKxBPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyaNesticbFkcc0H5u33xNdigPkg4gCf2B9h5tdV/zW/xgr/Z+kJMvZaY0JHCJlom
	 ZtXZRZp16U95FE6nhWLwyQx8qB/qVxeuTGW93NXQSMTqQO0DvWo395GYZSECbfm3QA
	 DdIWlEmHtikXCrnUvYi0PU0C/iGBXD+AhO9HQ2wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/187] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Mon,  1 Dec 2025 12:23:11 +0100
Message-ID: <20251201112244.230869061@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 53d591730ea34f97a82f7ec6e7c987ca6e34dc21 ]

Constrained test environment; duplicate address detection is not needed
and causes races so disable it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index d2ac09b35dcf5..e3657454816b9 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -376,6 +376,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



