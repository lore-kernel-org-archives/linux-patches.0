Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8C2DFF18;
	Tue, 17 Jun 2025 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179001; cv=none; b=c4ReDaKNrNibfzY2ZYLI8E0bbaaaAkJJT31M8yHfd7JUh6EAjf5pKTyxC7ahyRCw0iBwLU4ewcr0DOr2PRktPpoUVfpAWG+2utbSSDu+yePBf+rRQQS26OwtlEH1gtwSM96SvRi9VhwvaZC1eyA56eDOcf/kwu9fvN6yhpBLIfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179001; c=relaxed/simple;
	bh=ckH5VFbzTPffED+CmH7PLM/OFis3Vv8A1yeTEhAGT/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=km2ZLRSEI0USIfN/Wrph9WdZvOnyXEEMHRhe5SZnh2DZan4BKzhcx+rI7fWRKChjfPZdmnghGaZzOIH5pJ8mUS9F1xDEhi/rEw9ldA6f332V7lyRi8p26sQsQpqhAnjmEQom+dRmdwFTpnlSP4pG3xpq5qGYPVsjLsAiRqMYogw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Az04VFkC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Az04VFkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8F1C4CEE3;
	Tue, 17 Jun 2025 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179001;
	bh=ckH5VFbzTPffED+CmH7PLM/OFis3Vv8A1yeTEhAGT/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Az04VFkCqSGO2a39Sp8u2C5XbOTqwQ/LbN/eHrtU/oBqJjOcnukICpFHoOVETZLAz
	 qqHTA81/sI3CcsIqkVu74HTGr8w5/1CHP6PDdpxUNMXF63HsAFh2wvviTtHX32Q2/p
	 49HApX0Wizh3+bNZHuxqNvssazj9fL+HkUNCC4a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 618/780] netlink: specs: rt-link: add missing byte-order properties
Date: Tue, 17 Jun 2025 17:25:26 +0200
Message-ID: <20250617152516.647942827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit de92258e3b22bd4ce920715cc91f09d788e5badf ]

A number of fields in the ip tunnels are lacking the big-endian
designation. I suspect this is not intentional, as decoding
the ports with the right endian seems objectively beneficial.

Fixes: 6ffdbb93a59c ("netlink: specs: rt_link: decode ip6tnl, vti and vti6 link attrs")
Fixes: 077b6022d24b ("doc/netlink/specs: Add sub-message type to rt_link family")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250603135357.502626-2-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index 6b9d5ee87d93a..ba767c42e8792 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1778,15 +1778,19 @@ attribute-sets:
       -
         name: iflags
         type: u16
+        byte-order: big-endian
       -
         name: oflags
         type: u16
+        byte-order: big-endian
       -
         name: ikey
         type: u32
+        byte-order: big-endian
       -
         name: okey
         type: u32
+        byte-order: big-endian
       -
         name: local
         type: binary
@@ -1810,6 +1814,7 @@ attribute-sets:
       -
         name: flowinfo
         type: u32
+        byte-order: big-endian
       -
         name: flags
         type: u32
@@ -1822,9 +1827,11 @@ attribute-sets:
       -
         name: encap-sport
         type: u16
+        byte-order: big-endian
       -
         name: encap-dport
         type: u16
+        byte-order: big-endian
       -
         name: collect-metadata
         type: flag
@@ -1856,9 +1863,11 @@ attribute-sets:
       -
         name: ikey
         type: u32
+        byte-order: big-endian
       -
         name: okey
         type: u32
+        byte-order: big-endian
       -
         name: local
         type: binary
@@ -1908,6 +1917,7 @@ attribute-sets:
       -
         name: port
         type: u16
+        byte-order: big-endian
       -
         name: collect-metadata
         type: flag
@@ -1927,6 +1937,7 @@ attribute-sets:
       -
         name: label
         type: u32
+        byte-order: big-endian
       -
         name: ttl-inherit
         type: u8
@@ -1967,9 +1978,11 @@ attribute-sets:
       -
         name: flowinfo
         type: u32
+        byte-order: big-endian
       -
         name: flags
         type: u16
+        byte-order: big-endian
       -
         name: proto
         type: u8
@@ -1999,9 +2012,11 @@ attribute-sets:
       -
         name: encap-sport
         type: u16
+        byte-order: big-endian
       -
         name: encap-dport
         type: u16
+        byte-order: big-endian
       -
         name: collect-metadata
         type: flag
-- 
2.39.5



