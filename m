Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC365390
	for <patches@lists.linux.dev>; Fri,  8 Sep 2023 14:53:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1FB121D24;
	Fri,  8 Sep 2023 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1694184798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jWUuKHA14Ro80eW+EcXMts9c3gnZ7g0AX+XfQ4t1ggo=;
	b=Ofhto8mBB6G/WsRstp537Zic9CQSDdhN6TRK0U/zjUBosx5Jm4nYvx+3Q4XibW+tIzdBEU
	TG/TQ3RELRcc16jMAmPLpYXNvybxpwzf6JfRCw1FAMUSAMDvb2tShc5MbywQ6QVBIIC2MZ
	/WnoLDMNHcf6bG5Cic50TeNdme2d6rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1694184798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=jWUuKHA14Ro80eW+EcXMts9c3gnZ7g0AX+XfQ4t1ggo=;
	b=pJOd4bGthsdKOztl2YrI8Zl1MZINaACKK+ir2PQ5tmQZNxaSEOtVZ6Iqh5Sn+ieEScDVO2
	l/ejWD0T1dAuZZAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E385131FD;
	Fri,  8 Sep 2023 14:53:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 1/TnJV41+2QaBQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 08 Sep 2023 14:53:18 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Jay Patel <jaypatel@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	linux-mm@kvack.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/4] SLUB: calculate_order() cleanups
Date: Fri,  8 Sep 2023 16:53:03 +0200
Message-ID: <20230908145302.30320-6-vbabka@suse.cz>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since reviewing recent patches made me finally dig into these functions
in details for the first time, I've also noticed some opportunities for
cleanups that should make them simpler and also deliver more consistent
results for some corner case object sizes (probably not seen in
practice). Thus patch 3 can increase slab orders somewhere, but only in
the way that was already intended. Otherwise it's almost no functional
changes.

Vlastimil Babka (4):
  mm/slub: simplify the last resort slab order calculation
  mm/slub: remove min_objects loop from calculate_order()
  mm/slub: attempt to find layouts up to 1/2 waste in calculate_order()
  mm/slub: refactor calculate_order() and calc_slab_order()

 mm/slub.c | 63 ++++++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 36 deletions(-)

-- 
2.42.0

