Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE2A1DEFCF;
	Tue,  8 Oct 2024 12:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390796; cv=none; b=CK7rr3hzta56NgndKYUP2qMOwe43lqybBxe1NC/oEaToy+u+5/loT9DegY8oKUiel2rqU9RuDEyNSr6cO1eVhmRrY6bCKZkeJAcOHCOZ53WkWfDxFPFPGSqx7tHGYCZ/9YsArf0YtC2OUDTCSWd4hUBZtR0/uoFWd9WZUkrC1ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390796; c=relaxed/simple;
	bh=ehhZjRRrv1kS6XSJ1i1Y5i9T7JmSf7LgiMeH4in5TPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kv8Ytkfzhf+iMq25HCUTZI+ajyIPPESnk13FDxXmRX9lM76xbe4sV6BHgns3XdrE91t7P0TXIjtM7OoG1acbCCGB3Pm1lCpBIY8TExn6OJzaYdVvNoLRJBAsT1ze7A1EXGsc+P+E3y0tPfEjuRf1Ffrzmmr6Z0anHW/TvBUZCmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMioBN0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMioBN0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13736C4CECD;
	Tue,  8 Oct 2024 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390795;
	bh=ehhZjRRrv1kS6XSJ1i1Y5i9T7JmSf7LgiMeH4in5TPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMioBN0sbLWlucqfNYMU7OWJ1CNMFjBouBscrdVuWNgDsiBmtKs9/EHrqQxOY6raL
	 qCcGt/fAyO+7IbA3wwJvyMa+wtekDnCpcZQCwLEe21TvPPLv5EsKd1+6bDrwUkIVpi
	 1PqLkb95KoFQhFXhFs02kJA46VUUQvXxC3cSE4j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 6.10 364/482] sched/deadline: Comment sched_dl_entity::dl_server variable
Date: Tue,  8 Oct 2024 14:07:07 +0200
Message-ID: <20241008115702.747903030@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit f23c042ce34ba265cf3129d530702b5d218e3f4b upstream.

Add an explanation for the newly added variable.

Fixes: 63ba8422f876 ("sched/deadline: Introduce deadline servers")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Juri Lelli <juri.lelli@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/147f7aa8cb8fd925f36aa8059af6a35aad08b45a.1716811044.git.bristot@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -637,6 +637,8 @@ struct sched_dl_entity {
 	 *
 	 * @dl_overrun tells if the task asked to be informed about runtime
 	 * overruns.
+	 *
+	 * @dl_server tells if this is a server entity.
 	 */
 	unsigned int			dl_throttled      : 1;
 	unsigned int			dl_yielded        : 1;


