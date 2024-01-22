Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEDF4C89;
	Mon, 22 Jan 2024 05:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705901918; cv=none; b=cCKbCUAtCokJqOT2PT3C5GGsf7zotT93Bk0jgfMRqMD+6zXKtyEwcfUzsmZumNMjbAcDsU+JSpUQ5FFWrGCJMhdZcncKzhfZ69dhyQGWSN6Ac1nTig5sgFBeSJMaOKeTXzTEaJL9s+EHJ+xgjvEliPP8xVXfkh7sbN5Cd7TT6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705901918; c=relaxed/simple;
	bh=ZusmTspSWAxPpMQJMLsKcpiaMKNK+ZNVCj0SX6j10Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BglyE0jrGUZl+r2ThDISKq0lpI5WZwTr2thAy7a3Tr27X12ra9RTunX+MEqz9/VYyR4cofOcrdV671fta4cgCiqaQv8E1jagAA1m5XMoP9GwYy0flYRuRZJY0oRh4Yqyxj3YZmzHkmbxgGtt/3E3pll7JSP1xQbo7cQ93tZ8arY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NDrEJTpG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NDrEJTpG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1sKEEoC2Kl+4lU7cEEy5z49Em6IE6n6um+Bwz1YXVRw=; b=NDrEJTpGZ9OMltN4g02yn1/sOv
	qnRD53ou1TFy2dnR3rI+XIj0hJ1sY5MV7TzNOR/mL1paVlTx8gR4TttOgmpCJzCCgPmr1WtM+iFeA
	ZMaofNjwgg9clA3lQpMNGVDIQphaKRC1JGTvBjjSA5yb+ypD83Owy+Bo3nURK72zGdlc73kERUKN/
	viL2nkA4S9GDlcRNYwZr9bzp328q8dhgX6tyg1mX3x68X4MgJ+MoFl1K73z4IydjMvxUDkSMSTMeQ
	MSnoMfI3Ezn1/1pI+4bKmUeM9TqohGkq9w60KhRAA87+kOJdby+QV/JCthIuCfteU3myrEHK73LQv
	h8jzhEqw==;
Received: from [50.53.50.0] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rRn0z-00AciO-2b;
	Mon, 22 Jan 2024 05:38:33 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	v9fs@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] 9p/trans_fd: remove Excess kernel-doc comment
Date: Sun, 21 Jan 2024 21:38:32 -0800
Message-ID: <20240122053832.15811-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the "@req" kernel-doc description since there is not 'req'
member in the struct p9_conn.

Fixes one kernel-doc warning:
trans_fd.c:133: warning: Excess struct member 'req' description in 'p9_conn'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: v9fs@lists.linux.dev
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 net/9p/trans_fd.c |    1 -
 1 file changed, 1 deletion(-)

diff -- a/net/9p/trans_fd.c b/net/9p/trans_fd.c
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -95,7 +95,6 @@ struct p9_poll_wait {
  * @unsent_req_list: accounting for requests that haven't been sent
  * @rreq: read request
  * @wreq: write request
- * @req: current request being processed (if any)
  * @tmp_buf: temporary buffer to read in header
  * @rc: temporary fcall for reading current frame
  * @wpos: write position for current frame
