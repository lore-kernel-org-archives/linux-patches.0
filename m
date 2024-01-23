Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD4B46AB;
	Tue, 23 Jan 2024 05:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705986724; cv=none; b=eEwSXjYTHu1/ko5s9eVEepaw0xhchCsTFteNVdDG8OJ2KQj1xgNUpTyhjea0NWHjLZ+5pMtWZDQOKcv9oA4e9po+oecshm2XxGTS4sSkLBT0i2/DKQaUjiIQ+Kdw6oL++wtQ2JxD6crGaeRh36FszsioKtLAftqrUwepmSiZM8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705986724; c=relaxed/simple;
	bh=snsJC136EsxeMjRyRrr5nqUNuoswvRVM/1tSC7nK3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=poVnHE4kBWZVr3vypbGHGyZD2mQ9vcKYMpQC9gBkpmA1kEqq/oS4DXbFysinHWd4WQ4DV3PU8Gbf09i+EDQyXPBCmehnkzQFqeLAmF/GglBiTKnsVk4J5nqgtgofrOk+RJ3VTHyM9k0mMA/U+zqhN7JPziVWHmoNOYv/I5QnZrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2K/k3RZe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2K/k3RZe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PBzYd1B/1DgsFcocc0KGkyfJ5l6LvBwfL151TplKcQw=; b=2K/k3RZeHPBMJSApFMk8K50k8J
	s6sM/0AB6CiBm74CGzhJNvDrI7VLbORymaXjfyHCRMBHMpkg3AUv8j9tCTu3YRivt8fpgSl0RR/72
	7z1lV5zPMw03z1IzobinqOe3QVqYwAebfkmhMU4Z1CnvL4VTDgI9GxaT/F9ASNCbDyLZ4lyOml/4M
	pT0fXRu8kjIqKyeP70Xp2UNt3COmj9koD8sc1odGxyZymB6Wb42+uxTdT21+qL2pBgtir2zuqFN2K
	9BH59PsZZPmTQJ441XbFEwRD/3btlDUkVh9AM2zsOYicFigwBbn1J1O6q9HF+nY/Byltm9yCifuj8
	IPfrectg==;
Received: from [50.53.50.0] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS94s-00F7Dz-1J;
	Tue, 23 Jan 2024 05:12:02 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jon Maloy <jmaloy@redhat.com>,
	Ying Xue <ying.xue@windriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH resend] tipc: socket: remove Excess struct member kernel-doc warning
Date: Mon, 22 Jan 2024 21:12:01 -0800
Message-ID: <20240123051201.24701-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove a kernel-doc description to squelch a warning:

socket.c:143: warning: Excess struct member 'blocking_link' description in 'tipc_sock'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Simon Horman <horms@kernel.org>
---
Resend after merge window has closed.

 net/tipc/socket.c |    1 -
 1 file changed, 1 deletion(-)

diff -- a/net/tipc/socket.c b/net/tipc/socket.c
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -80,7 +80,6 @@ struct sockaddr_pair {
  * @phdr: preformatted message header used when sending messages
  * @cong_links: list of congested links
  * @publications: list of publications for port
- * @blocking_link: address of the congested link we are currently sleeping on
  * @pub_count: total # of publications port has made during its lifetime
  * @conn_timeout: the time we can wait for an unresponded setup request
  * @probe_unacked: probe has not received ack yet
