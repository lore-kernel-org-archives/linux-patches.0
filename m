Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142E03793CE;
	Thu, 20 Aug 2026 16:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244507; cv=none; b=NoX0OBkdt75cf1N1erLpmyC4X6djPJFXmRxO47h7T4eAIb0LT7iOwc57S8rZapRpfO0xzgEO7eva/psCs7Z1q4Uj+0tK8m32tYETQVwkDDVr4ErPg/u/cJTNQfRxkrV0QXnevh4V78Klh12Fq6XTGkDcNKG1aRPnnt6iey+EnWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244507; c=relaxed/simple;
	bh=N5IemQHMYMHV1hqCpX0tMwgkquJPu+tV3zDfSGy2hCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkVX+REGulDlIZjm56HkD7UMd5tBsv05uA8QOWf/t4kz1Agi4GN5YJ2tp4ttNO8n/L2voAxrVTSd2P9JoUPedecNIb1VlbHWfv2bHQzOeWDrJS9XnO0KHOGze0vt4f9gVYEfndhwDZ79/UvzY+brYOBggNR8bWmciGtHLj1XaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6bIiGmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6bIiGmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6951F000E9;
	Thu, 20 Aug 2026 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244506;
	bh=euvceobV5Bp3wn6tkxggf5dClDUaHLo2jFqByfQ96WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6bIiGmfIYFmjQsgqhCKlTsckcqbdno+RRy7Hho5uepFGJi7zzW7QuQlSUUC1CA5p
	 Fo6/LwGQNRfX0Kdj5lf/N35DcTWDt5sijoCi5m/OF9j0BH7ZY6kDKUYNlFgrMGZRvx
	 gffIDh7o1kHbTNQB3MJn1AQ8V4Iow8uvFwZUbOTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/235] net: pktgen: fix code style (WARNING: Block comments)
Date: Thu, 20 Aug 2026 16:57:09 +0200
Message-ID: <20260820145222.397915658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Seiderer <ps.report@gmx.net>

[ Upstream commit 870b856cb478bc02fffe4d89897e62c692efb09a ]

Fix checkpatch code style warnings:

  WARNING: Block comments use a trailing */ on a separate line
  +                                * removal by worker thread */

  WARNING: Block comments use * on subsequent lines
  +       __u8 tos;            /* six MSB of (former) IPv4 TOS
  +                               are for dscp codepoint */

  WARNING: Block comments use a trailing */ on a separate line
  +                               are for dscp codepoint */

  WARNING: Block comments use * on subsequent lines
  +       __u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
  +                               (see RFC 3260, sec. 4) */

  WARNING: Block comments use a trailing */ on a separate line
  +                               (see RFC 3260, sec. 4) */

  WARNING: Block comments use * on subsequent lines
  +       /* = {
  +          0x00, 0x80, 0xC8, 0x79, 0xB3, 0xCB,

  WARNING: Block comments use * on subsequent lines
  +       /* Field for thread to receive "posted" events terminate,
  +          stop ifs etc. */

  WARNING: Block comments use a trailing */ on a separate line
  +          stop ifs etc. */

  WARNING: Block comments should align the * on each line
  + * we go look for it ...
  +*/

  WARNING: Block comments use a trailing */ on a separate line
  +        * we resolve the dst issue */

  WARNING: Block comments use a trailing */ on a separate line
  +        * with proc_create_data() */

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 817ff6efdb7f ("net: pktgen: fix proc entry use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -275,7 +275,8 @@ struct pktgen_dev {
 	int pkt_overhead;	/* overhead for MPLS, VLANs, IPSEC etc */
 	int nfrags;
 	int removal_mark;	/* non-zero => the device is marked for
-				 * removal by worker thread */
+				 * removal by worker thread
+				 */
 
 	struct page *page;
 	u64 delay;		/* nano-seconds */
@@ -338,10 +339,12 @@ struct pktgen_dev {
 	__u16 udp_dst_max;	/* exclusive, dest UDP port */
 
 	/* DSCP + ECN */
-	__u8 tos;            /* six MSB of (former) IPv4 TOS
-				are for dscp codepoint */
-	__u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
-				(see RFC 3260, sec. 4) */
+	__u8 tos;		/* six MSB of (former) IPv4 TOS
+				 * are for dscp codepoint
+				 */
+	__u8 traffic_class;	/* ditto for the (former) Traffic Class in IPv6
+				 * (see RFC 3260, sec. 4)
+				 */
 
 	/* MPLS */
 	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
@@ -375,12 +378,12 @@ struct pktgen_dev {
 
 	__u8 hh[14];
 	/* = {
-	   0x00, 0x80, 0xC8, 0x79, 0xB3, 0xCB,
-
-	   We fill in SRC address later
-	   0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	   0x08, 0x00
-	   };
+	 * 0x00, 0x80, 0xC8, 0x79, 0xB3, 0xCB,
+	 *
+	 * We fill in SRC address later
+	 * 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	 * 0x08, 0x00
+	 * };
 	 */
 	__u16 pad;		/* pad out the hh struct to an even 16 bytes */
 
@@ -443,7 +446,8 @@ struct pktgen_thread {
 	char result[512];
 
 	/* Field for thread to receive "posted" events terminate,
-	   stop ifs etc. */
+	 * stop ifs etc.
+	 */
 
 	u32 control;
 	int cpu;
@@ -2235,7 +2239,7 @@ static inline int f_pick(struct pktgen_d
 #ifdef CONFIG_XFRM
 /* If there was already an IPSEC SA, we keep it as is, else
  * we go look for it ...
-*/
+ */
 #define DUMMY_MARK 0
 static void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
 {
@@ -2506,7 +2510,8 @@ static int pktgen_output_ipsec(struct sk
 	if (!x)
 		return 0;
 	/* XXX: we dont support tunnel mode for now until
-	 * we resolve the dst issue */
+	 * we resolve the dst issue
+	 */
 	if ((x->props.mode != XFRM_MODE_TRANSPORT) && (pkt_dev->spi == 0))
 		return 0;
 
@@ -3569,7 +3574,8 @@ static int add_dev_to_thread(struct pktg
 	 * userspace on another CPU than the kthread.  The if_lock()
 	 * is used here to sync with concurrent instances of
 	 * _rem_dev_from_if_list() invoked via kthread, which is also
-	 * updating the if_list */
+	 * updating the if_list
+	 */
 	if_lock(t);
 
 	if (pkt_dev->pg_thread) {
@@ -3766,7 +3772,8 @@ static int pktgen_remove_device(struct p
 
 	/* Remove proc before if_list entry, because add_device uses
 	 * list to determine if interface already exist, avoid race
-	 * with proc_create_data() */
+	 * with proc_create_data()
+	 */
 	proc_remove(pkt_dev->entry);
 
 	/* And update the thread if_list */


