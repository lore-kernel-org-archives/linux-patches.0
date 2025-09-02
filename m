Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C644432ED2E;
	Tue,  2 Sep 2025 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820825; cv=none; b=BOrEVXAbJyVogiJfMzXVms0eO6+rl7XjJ6UtOWGE8jecjEhRqZdp7E3mHaRV/KNR7GjpUh4r6cs+RqFvPnwyqiJJ7MgdaF4q1cd2uCu4tcAyKM717sxjVcvH6m39N59Q4zEqSuKUDmz45PW68wBXw2ITV7/bVLUMwXL+vRp7vtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820825; c=relaxed/simple;
	bh=Zsgw9zZ9s/KBloSuycJGNbtCCiBHMb39sIbK5DpY4MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHbxWpf7PN8HQ1PeBNwPEcCHLoPw0CSVDulpuduOwmo+WLXvKZDPxOZY97imcNo43dACbRSFMsu0KhPSvz+yDaBR63Fi0PN+0y7dMjyKLmWjdI5I/4he6pGpWynZkl3f+Cgn245qyKWJRr9o6z3Un2iKViYl7xJzY0YyjJZha+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCHxY+Dj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCHxY+Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC86C4CEED;
	Tue,  2 Sep 2025 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820825;
	bh=Zsgw9zZ9s/KBloSuycJGNbtCCiBHMb39sIbK5DpY4MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCHxY+DjWqs1tYD7EWpi83QDq9slfiFXgWdNgltJ4BKp/4KBXDhl6Meo8G8iPdXxt
	 KMexYe0QEnCwDE2XXwLDr2VkePdnKWncO5yytsLXEGRuGUKNW/dFTjoSjr86Z++0YQ
	 wz7bCYfU2/t6IbMkvxcpV67aGrkN/9eYkwqvKUp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/23] net/atm: remove the atmdev_ops {get, set}sockopt methods
Date: Tue,  2 Sep 2025 15:21:54 +0200
Message-ID: <20250902131925.053815639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a06d30ae7af492497ffbca6abf1621d508b8fcaa ]

All implementations of these two methods are dummies that always
return -EINVAL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ec79003c5f9d ("atm: atmtcp: Prevent arbitrary write in atmtcp_recv_control().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/eni.c        | 17 -----------------
 drivers/atm/firestream.c |  2 --
 drivers/atm/fore200e.c   | 27 ---------------------------
 drivers/atm/horizon.c    | 40 ----------------------------------------
 drivers/atm/iphase.c     | 16 ----------------
 drivers/atm/lanai.c      |  2 --
 drivers/atm/solos-pci.c  |  2 --
 drivers/atm/zatm.c       | 16 ----------------
 include/linux/atmdev.h   |  9 ---------
 net/atm/common.c         | 14 ++------------
 10 files changed, 2 insertions(+), 143 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 4816db0553ef8..0f082bd626543 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2035,21 +2035,6 @@ static int eni_ioctl(struct atm_dev *dev,unsigned int cmd,void __user *arg)
 	return dev->phy->ioctl(dev,cmd,arg);
 }
 
-
-static int eni_getsockopt(struct atm_vcc *vcc,int level,int optname,
-    void __user *optval,int optlen)
-{
-	return -EINVAL;
-}
-
-
-static int eni_setsockopt(struct atm_vcc *vcc,int level,int optname,
-    void __user *optval,unsigned int optlen)
-{
-	return -EINVAL;
-}
-
-
 static int eni_send(struct atm_vcc *vcc,struct sk_buff *skb)
 {
 	enum enq_res res;
@@ -2223,8 +2208,6 @@ static const struct atmdev_ops ops = {
 	.open		= eni_open,
 	.close		= eni_close,
 	.ioctl		= eni_ioctl,
-	.getsockopt	= eni_getsockopt,
-	.setsockopt	= eni_setsockopt,
 	.send		= eni_send,
 	.phy_put	= eni_phy_put,
 	.phy_get	= eni_phy_get,
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 8995c39330fac..c7c3aeecd1c61 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1278,8 +1278,6 @@ static const struct atmdev_ops ops = {
 	.send =         fs_send,
 	.owner =        THIS_MODULE,
 	/* ioctl:          fs_ioctl, */
-	/* getsockopt:     fs_getsockopt, */
-	/* setsockopt:     fs_setsockopt, */
 	/* change_qos:     fs_change_qos, */
 
 	/* For now implement these internally here... */  
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 8fbd36eb89410..a36f555cc0403 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1710,31 +1710,6 @@ fore200e_getstats(struct fore200e* fore200e)
     return 0;
 }
 
-
-static int
-fore200e_getsockopt(struct atm_vcc* vcc, int level, int optname, void __user *optval, int optlen)
-{
-    /* struct fore200e* fore200e = FORE200E_DEV(vcc->dev); */
-
-    DPRINTK(2, "getsockopt %d.%d.%d, level = %d, optname = 0x%x, optval = 0x%p, optlen = %d\n",
-	    vcc->itf, vcc->vpi, vcc->vci, level, optname, optval, optlen);
-
-    return -EINVAL;
-}
-
-
-static int
-fore200e_setsockopt(struct atm_vcc* vcc, int level, int optname, void __user *optval, unsigned int optlen)
-{
-    /* struct fore200e* fore200e = FORE200E_DEV(vcc->dev); */
-    
-    DPRINTK(2, "setsockopt %d.%d.%d, level = %d, optname = 0x%x, optval = 0x%p, optlen = %d\n",
-	    vcc->itf, vcc->vpi, vcc->vci, level, optname, optval, optlen);
-    
-    return -EINVAL;
-}
-
-
 #if 0 /* currently unused */
 static int
 fore200e_get_oc3(struct fore200e* fore200e, struct oc3_regs* regs)
@@ -3026,8 +3001,6 @@ static const struct atmdev_ops fore200e_ops = {
 	.open       = fore200e_open,
 	.close      = fore200e_close,
 	.ioctl      = fore200e_ioctl,
-	.getsockopt = fore200e_getsockopt,
-	.setsockopt = fore200e_setsockopt,
 	.send       = fore200e_send,
 	.change_qos = fore200e_change_qos,
 	.proc_read  = fore200e_proc_read,
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index e5da51f907a25..4f2951cbe69c0 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2527,46 +2527,6 @@ static void hrz_close (struct atm_vcc * atm_vcc) {
   clear_bit(ATM_VF_ADDR,&atm_vcc->flags);
 }
 
-#if 0
-static int hrz_getsockopt (struct atm_vcc * atm_vcc, int level, int optname,
-			   void *optval, int optlen) {
-  hrz_dev * dev = HRZ_DEV(atm_vcc->dev);
-  PRINTD (DBG_FLOW|DBG_VCC, "hrz_getsockopt");
-  switch (level) {
-    case SOL_SOCKET:
-      switch (optname) {
-//	case SO_BCTXOPT:
-//	  break;
-//	case SO_BCRXOPT:
-//	  break;
-	default:
-	  return -ENOPROTOOPT;
-      };
-      break;
-  }
-  return -EINVAL;
-}
-
-static int hrz_setsockopt (struct atm_vcc * atm_vcc, int level, int optname,
-			   void *optval, unsigned int optlen) {
-  hrz_dev * dev = HRZ_DEV(atm_vcc->dev);
-  PRINTD (DBG_FLOW|DBG_VCC, "hrz_setsockopt");
-  switch (level) {
-    case SOL_SOCKET:
-      switch (optname) {
-//	case SO_BCTXOPT:
-//	  break;
-//	case SO_BCRXOPT:
-//	  break;
-	default:
-	  return -ENOPROTOOPT;
-      };
-      break;
-  }
-  return -EINVAL;
-}
-#endif
-
 #if 0
 static int hrz_ioctl (struct atm_dev * atm_dev, unsigned int cmd, void *arg) {
   hrz_dev * dev = HRZ_DEV(atm_dev);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index bfc889367d5e3..cc90f550ab75a 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2882,20 +2882,6 @@ static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)
    return 0;  
 }  
   
-static int ia_getsockopt(struct atm_vcc *vcc, int level, int optname,   
-	void __user *optval, int optlen)  
-{  
-	IF_EVENT(printk(">ia_getsockopt\n");)  
-	return -EINVAL;  
-}  
-  
-static int ia_setsockopt(struct atm_vcc *vcc, int level, int optname,   
-	void __user *optval, unsigned int optlen)  
-{  
-	IF_EVENT(printk(">ia_setsockopt\n");)  
-	return -EINVAL;  
-}  
-  
 static int ia_pkt_tx (struct atm_vcc *vcc, struct sk_buff *skb) {
         IADEV *iadev;
         struct dle *wr_ptr;
@@ -3166,8 +3152,6 @@ static const struct atmdev_ops ops = {
 	.open		= ia_open,  
 	.close		= ia_close,  
 	.ioctl		= ia_ioctl,  
-	.getsockopt	= ia_getsockopt,  
-	.setsockopt	= ia_setsockopt,  
 	.send		= ia_send,  
 	.phy_put	= ia_phy_put,  
 	.phy_get	= ia_phy_get,  
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index c6b38112bcf4f..2ed832e1dafa2 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -2540,8 +2540,6 @@ static const struct atmdev_ops ops = {
 	.dev_close	= lanai_dev_close,
 	.open		= lanai_open,
 	.close		= lanai_close,
-	.getsockopt	= NULL,
-	.setsockopt	= NULL,
 	.send		= lanai_send,
 	.phy_put	= NULL,
 	.phy_get	= NULL,
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 9f2148daf8ad1..669466d010efa 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -1179,8 +1179,6 @@ static const struct atmdev_ops fpga_ops = {
 	.open =		popen,
 	.close =	pclose,
 	.ioctl =	NULL,
-	.getsockopt =	NULL,
-	.setsockopt =	NULL,
 	.send =		psend,
 	.send_oam =	NULL,
 	.phy_put =	NULL,
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index 165eebe06e39e..ee059c77e3bbc 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -1515,20 +1515,6 @@ static int zatm_ioctl(struct atm_dev *dev,unsigned int cmd,void __user *arg)
 	}
 }
 
-
-static int zatm_getsockopt(struct atm_vcc *vcc,int level,int optname,
-    void __user *optval,int optlen)
-{
-	return -EINVAL;
-}
-
-
-static int zatm_setsockopt(struct atm_vcc *vcc,int level,int optname,
-    void __user *optval,unsigned int optlen)
-{
-	return -EINVAL;
-}
-
 static int zatm_send(struct atm_vcc *vcc,struct sk_buff *skb)
 {
 	int error;
@@ -1582,8 +1568,6 @@ static const struct atmdev_ops ops = {
 	.open		= zatm_open,
 	.close		= zatm_close,
 	.ioctl		= zatm_ioctl,
-	.getsockopt	= zatm_getsockopt,
-	.setsockopt	= zatm_setsockopt,
 	.send		= zatm_send,
 	.phy_put	= zatm_phy_put,
 	.phy_get	= zatm_phy_get,
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index 19c0f91c38bdd..bc24d19ec2b37 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -176,11 +176,6 @@ struct atm_dev {
 #define ATM_OF_IMMED  1		/* Attempt immediate delivery */
 #define ATM_OF_INRATE 2		/* Attempt in-rate delivery */
 
-
-/*
- * ioctl, getsockopt, and setsockopt are optional and can be set to NULL.
- */
-
 struct atmdev_ops { /* only send is required */
 	void (*dev_close)(struct atm_dev *dev);
 	int (*open)(struct atm_vcc *vcc);
@@ -190,10 +185,6 @@ struct atmdev_ops { /* only send is required */
 	int (*compat_ioctl)(struct atm_dev *dev,unsigned int cmd,
 			    void __user *arg);
 #endif
-	int (*getsockopt)(struct atm_vcc *vcc,int level,int optname,
-	    void __user *optval,int optlen);
-	int (*setsockopt)(struct atm_vcc *vcc,int level,int optname,
-	    void __user *optval,unsigned int optlen);
 	int (*send)(struct atm_vcc *vcc,struct sk_buff *skb);
 	int (*send_oam)(struct atm_vcc *vcc,void *cell,int flags);
 	void (*phy_put)(struct atm_dev *dev,unsigned char value,
diff --git a/net/atm/common.c b/net/atm/common.c
index 1e07a5fc53d05..a51994aba34c4 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -783,13 +783,8 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
 			vcc->atm_options &= ~ATM_ATMOPT_CLP;
 		return 0;
 	default:
-		if (level == SOL_SOCKET)
-			return -EINVAL;
-		break;
-	}
-	if (!vcc->dev || !vcc->dev->ops->setsockopt)
 		return -EINVAL;
-	return vcc->dev->ops->setsockopt(vcc, level, optname, optval, optlen);
+	}
 }
 
 int vcc_getsockopt(struct socket *sock, int level, int optname,
@@ -827,13 +822,8 @@ int vcc_getsockopt(struct socket *sock, int level, int optname,
 		return copy_to_user(optval, &pvc, sizeof(pvc)) ? -EFAULT : 0;
 	}
 	default:
-		if (level == SOL_SOCKET)
-			return -EINVAL;
-		break;
-	}
-	if (!vcc->dev || !vcc->dev->ops->getsockopt)
 		return -EINVAL;
-	return vcc->dev->ops->getsockopt(vcc, level, optname, optval, len);
+	}
 }
 
 int register_atmdevice_notifier(struct notifier_block *nb)
-- 
2.50.1



