Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBFD51C2D;
	Mon, 11 Dec 2023 18:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yu9aOb79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FBFC433C8;
	Mon, 11 Dec 2023 18:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320768;
	bh=0a9ujQ1Ncw9/EYTP/CWNuYkSRO/kidN/Op+eFDU0J78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yu9aOb79KNPeerElJzRIBZXghuS4FqRiGYUr3HGnz8C29kDq4d/uQJ0krmtMmwMQY
	 HW7Eu3KPgJvNQiaudQCWuifXiPSLvtahva+oTnMXl+0YBPZmTTdiRhOiG7gqLdIZEx
	 shFHpAopiIHiGSaRxqRoiUsoLkCXS1R09gpc3YDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Boehr <nrb@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 184/194] KVM: s390/mm: Properly reset no-dat
Date: Mon, 11 Dec 2023 19:22:54 +0100
Message-ID: <20231211182044.889737901@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

commit 27072b8e18a73ffeffb1c140939023915a35134b upstream.

When the CMMA state needs to be reset, the no-dat bit also needs to be
reset. Failure to do so could cause issues in the guest, since the
guest expects the bit to be cleared after a reset.

Cc: <stable@vger.kernel.org>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Message-ID: <20231109123624.37314-1-imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pgtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -731,7 +731,7 @@ void ptep_zap_unused(struct mm_struct *m
 		pte_clear(mm, addr, ptep);
 	}
 	if (reset)
-		pgste_val(pgste) &= ~_PGSTE_GPS_USAGE_MASK;
+		pgste_val(pgste) &= ~(_PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT);
 	pgste_set_unlock(ptep, pgste);
 	preempt_enable();
 }


