Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057408;
	b=cX0ewTS8QmFsG+IjMYmQ2qaHg6uTRftMSKYFa5FkZneI8kCFpYJStnDY5JRFw5LgrDqe
	 qVsm9oxKyY6A3q0JKq5Wo8JmeHQA8PmMidFd7wyeA19T91FgGILDQilZfWQKVjifP5HHB
	 Mqu+qJQNUCtZr8aZrlTpwlfA9hmhf7MgrAOFQhLMfzruE7wrYdVGv962+d6VPfkXdwYrm
	 S1WU1SNURxIeVJkKIIY6LXo4SFi2TacvSVyKSHn6tsd6b5qVa0tgHBrSoyA6NlxIsOUEQ
	 2/4cqvxn77dUsme4jo+UMhdUu4CFwUKnyMQ6rgeiNwHO90dbh9Iq0CVCY0GBQgSfH3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lzeEsP0jL8pi1+cdeolawdRKYEZm/QhnsyAIgVYZkpE=;
	b=wKzF+Q+qDhgib46fOI0O+w7EpT1OeIzqcrUMmpDkk8GRLae0rdiVVsZr2vcRiqz7QVay
	 7cOplGQYrd7o+phcFB4RpcyxUu5awoHlSpCsWtTqA2DfM5srdJfk5llZGQ+HGF6xTxtcj
	 TRB4NmP+PtvY8mRgun6hoTPt/uhZ9yCt8Q58RHKELdbAZ4Qj34JAHXsQBkGFHb+BFz36e
	 JtQNH1Jf+cX8eaiZWg8pqzT8mLb8UIeWLPNvcKubWsqWzOHtEzihwGqm5RA3STW2EvE5Z
	 jnElmninSoJI9UQBOo3YRKymtzNONhBSFHFpBuHXJsX8dFrDcXJ+kqH3vICIDgnHKBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0HBYzfsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF260A2601;
	Thu, 19 Nov 2026 03:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0HBYzfsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B861F000C4;
	Thu, 19 Nov 2026 03:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057408;
	bh=lzeEsP0jL8pi1+cdeolawdRKYEZm/QhnsyAIgVYZkpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0HBYzfsm/8wAp5PVwCEYo3ww+IqAAy9PqB2mvY7IVkmiXXWNqH8yWxdAtFtcDNPfz
	 LZfegZS7l2kWyiOTE2G+aMfR68qnMY0oLoY/WkBl/aLBcJ+KigAGiB6QWhgk4DebUc
	 5RRz/bOn9ST+YLgPm9jTnRvZf0aoAK6v1MehDBuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0120/1848] scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118145915.980369221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 0122eab60b151d7815f420a91c7315944a037714 ]

Unlike ibmvfc_tgt_implicit_logout the ibmvfc_tgt_implicit_logout_and_del
path fails to check for a NULL evt returned from
ibmvfc_get_reserved_event and passes that directly to ibmvfc_send_event
which will unconditionally derefence the evt.

Check for a NULL evt and perform same escalation as
ibmvfc_implicit_logout.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://patch.msgid.link/20260723000149.969416-4-tyreld@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 0a3da58d95229..34a2ac95bff8b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3713,6 +3713,14 @@ static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *tgt)
 	evt = __ibmvfc_tgt_get_implicit_logout_evt(tgt,
 						   ibmvfc_tgt_implicit_logout_and_del_done);
 
+	if (!evt) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+		__ibmvfc_reset_host(vhost);
+		return;
+	}
+
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_RPORT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
-- 
2.53.0



