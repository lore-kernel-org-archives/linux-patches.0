Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EDD3815E3;
	Thu, 20 Aug 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247110; cv=none; b=eN7xufpjuEnPPQIjnlxQG9OrrkAtCoPBaN4nvfoAIQllqy8rI2gtg8D4tCf5dM/hCmD5b0UMdranLIeeRmFXvY4NrdWO9nfXlo+YnPvsHLsnwcOyrQzLiILdc9HajiHa8Yvg786zD6RTjaMJ5EohhPxrkjrEQv/4XInTPtcImTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247110; c=relaxed/simple;
	bh=0a8wKqVzcYyUpBZF9AGoIzmpHkLMFgE1ILF5rYXd/HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUeJjDu+MZ6hqcw+1cU+ksLgVJttwG4JDamdYM4RzITC1Fsxl7oI77KPYWFZwoHvbfu0m2/+aLKrJOHyXasqIr/zVu9kWILSWza0b6QV1I4CBcPvtlZSe5AE59WPy56iahKml6kPBKefzyF4NlpY8jMZaDroFLryGGHT5KMhDIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBF4rRuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBF4rRuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7EB1F000E9;
	Thu, 20 Aug 2026 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247108;
	bh=KvXzjYkmiK8JTCueTZCpr/ms3I1X4+sI+R3CV8uVCsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBF4rRuMFNHyRj77i8+qP1UCSvNE1h0DfLA8yUD1AZIPPF3cZkmfSi4CT6PojstaK
	 7LRhTCIS4T9VKF1dzfQ7oDAqji8aEOCZ0Hgzj0g10AtWNB21hI3TNFqE9MIbOsH8+D
	 ZxYTFt5j5zyUSbDpr00zJijOZR3J84O4yAL/XVMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Seiderer <ps.report@gmx.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/220] net: pktgen: fix code style (WARNING: Block comments)
Date: Thu, 20 Aug 2026 16:55:43 +0200
Message-ID: <20260820145228.073151626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -285,7 +285,8 @@ struct pktgen_dev {
 	int pkt_overhead;	/* overhead for MPLS, VLANs, IPSEC etc */
 	int nfrags;
 	int removal_mark;	/* non-zero => the device is marked for
-				 * removal by worker thread */
+				 * removal by worker thread
+				 */
 
 	struct page *page;
 	u64 delay;		/* nano-seconds */
@@ -348,10 +349,12 @@ struct pktgen_dev {
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
 
 	/* IMIX */
 	unsigned int n_imix_entries;
@@ -391,12 +394,12 @@ struct pktgen_dev {
 
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
 
@@ -460,7 +463,8 @@ struct pktgen_thread {
 	char result[512];
 
 	/* Field for thread to receive "posted" events terminate,
-	   stop ifs etc. */
+	 * stop ifs etc.
+	 */
 
 	u32 control;
 	int cpu;
@@ -2364,7 +2368,7 @@ static inline int f_pick(struct pktgen_d
 #ifdef CONFIG_XFRM
 /* If there was already an IPSEC SA, we keep it as is, else
  * we go look for it ...
-*/
+ */
 #define DUMMY_MARK 0
 static void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
 {
@@ -2663,7 +2667,8 @@ static int pktgen_output_ipsec(struct sk
 	if (!x)
 		return 0;
 	/* XXX: we dont support tunnel mode for now until
-	 * we resolve the dst issue */
+	 * we resolve the dst issue
+	 */
 	if ((x->props.mode != XFRM_MODE_TRANSPORT) && (pkt_dev->spi == 0))
 		return 0;
 
@@ -3757,7 +3762,8 @@ static int add_dev_to_thread(struct pktg
 	 * userspace on another CPU than the kthread.  The if_lock()
 	 * is used here to sync with concurrent instances of
 	 * _rem_dev_from_if_list() invoked via kthread, which is also
-	 * updating the if_list */
+	 * updating the if_list
+	 */
 	if_lock(t);
 
 	if (pkt_dev->pg_thread) {
@@ -3955,7 +3961,8 @@ static int pktgen_remove_device(struct p
 
 	/* Remove proc before if_list entry, because add_device uses
 	 * list to determine if interface already exist, avoid race
-	 * with proc_create_data() */
+	 * with proc_create_data()
+	 */
 	proc_remove(pkt_dev->entry);
 
 	/* And update the thread if_list */


