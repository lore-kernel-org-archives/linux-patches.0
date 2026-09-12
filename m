Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88093B38A4;
	Sat, 12 Sep 2026 18:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239229; cv=none; b=CEoEGw1QrLl8blSNC2efzdEMUw9NUzz/JKc/ksraD66FXBQlstLMoaaUjHcDJLS3QqDR5Kf5RbwfXJOJ3u3b/ibydEOkCSII6VAg97QSvr7UbC9ba9uKf5+qG0xWe5waPHhK4YFoswMeLnrey6AfgDSpptbUwFjbA+3thFPPGKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239229; c=relaxed/simple;
	bh=HxTinAVmqn+yrHTnxSQHQAJnCjJJI8DYT33r8cbTRVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dydKWR53vsfjbtniWOkUWoD1l3cEofkW+EBmy78lp+ur9c8A/+31BitEFq25JBooaBUvrNyypnjA4hLJ/h6F5PcJcBakwGxEyPZ4I/bLTP8h5iiSy4hkkJ8cwh60O9R605CI1aebYEwGHKBruwQ+SwXz20uCtqKGDbDsOmnI9X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0PvP6qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0PvP6qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A72F1F000FF;
	Sat, 12 Sep 2026 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239227;
	bh=NyWQJ+7G+zLBdseej+ROfX3Q8dqVZpvkB6K2lywwPDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0PvP6qc8pSFp9A3ZsF9poGoQ85vfxTHere527jAmXR3cSp1Yio89QQpjELZ7OffE
	 +p/ufR/UqYkRqWNGuPK0kB/7coJCrO3g8tPEinFzBHsqpwaxyAv4zQNTmAgCc2+4B+
	 1Bxari8iUqmMao4b+Inua/SVfNdNn1/t6fRJfFa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 585/935] ath11k: add trace log support
Date: Sat, 12 Sep 2026 09:00:15 +0200
Message-ID: <20260912065540.254987709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkateswara Naralasetty <quic_vnaralas@quicinc.com>

[ Upstream commit fb12305aff12e735e599c79514dde5dac40f5a59 ]

This change is to add trace log support for,
        * WMI events
        * WMI commands
        * ath11k_dbg messages
        * ath11k_dbg_dump messages
        * ath11k_log_info messages
        * ath11k_log_warn messages
        * ath11k_log_err messages

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-00652-QCAHKSWPL_SILICONZ-1

Signed-off-by: Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1636439755-30419-1-git-send-email-quic_vnaralas@quicinc.com
Stable-dep-of: 9ef9dd30058c ("wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debug.c |  12 +-
 drivers/net/wireless/ath/ath11k/debug.h |   3 +-
 drivers/net/wireless/ath/ath11k/trace.c |   1 +
 drivers/net/wireless/ath/ath11k/trace.h | 172 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.c   |   4 +
 5 files changed, 187 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index c86de95fbdc58..958d874290624 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -17,7 +17,7 @@ void ath11k_info(struct ath11k_base *ab, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	dev_info(ab->dev, "%pV", &vaf);
-	/* TODO: Trace the log */
+	trace_ath11k_log_info(ab, &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL(ath11k_info);
@@ -32,7 +32,7 @@ void ath11k_err(struct ath11k_base *ab, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	dev_err(ab->dev, "%pV", &vaf);
-	/* TODO: Trace the log */
+	trace_ath11k_log_err(ab, &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL(ath11k_err);
@@ -47,7 +47,7 @@ void ath11k_warn(struct ath11k_base *ab, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	dev_warn_ratelimited(ab->dev, "%pV", &vaf);
-	/* TODO: Trace the log */
+	trace_ath11k_log_warn(ab, &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL(ath11k_warn);
@@ -68,7 +68,7 @@ void __ath11k_dbg(struct ath11k_base *ab, enum ath11k_debug_mask mask,
 	if (ath11k_debug_mask & mask)
 		dev_printk(KERN_DEBUG, ab->dev, "%pV", &vaf);
 
-	/* TODO: trace log */
+	trace_ath11k_log_dbg(ab, mask, &vaf);
 
 	va_end(args);
 }
@@ -100,6 +100,10 @@ void ath11k_dbg_dump(struct ath11k_base *ab,
 			dev_printk(KERN_DEBUG, ab->dev, "%s\n", linebuf);
 		}
 	}
+
+	/* tracing code doesn't like null strings */
+	trace_ath11k_log_dbg_dump(ab, msg ? msg : "", prefix ? prefix : "",
+				  buf, len);
 }
 EXPORT_SYMBOL(ath11k_dbg_dump);
 
diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index 694ebba17fad7..91545640c47b2 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -60,7 +60,8 @@ static inline void ath11k_dbg_dump(struct ath11k_base *ab,
 
 #define ath11k_dbg(ar, dbg_mask, fmt, ...)			\
 do {								\
-	if (ath11k_debug_mask & dbg_mask)			\
+	if ((ath11k_debug_mask & dbg_mask) ||			\
+	    trace_ath11k_log_dbg_enabled())			\
 		__ath11k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__);	\
 } while (0)
 
diff --git a/drivers/net/wireless/ath/ath11k/trace.c b/drivers/net/wireless/ath/ath11k/trace.c
index f0cc49ba0387f..6620650d78450 100644
--- a/drivers/net/wireless/ath/ath11k/trace.c
+++ b/drivers/net/wireless/ath/ath11k/trace.c
@@ -7,3 +7,4 @@
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+EXPORT_SYMBOL(__tracepoint_ath11k_log_dbg);
diff --git a/drivers/net/wireless/ath/ath11k/trace.h b/drivers/net/wireless/ath/ath11k/trace.h
index d2d2a3cb08269..4e7e5ab7c89dc 100644
--- a/drivers/net/wireless/ath/ath11k/trace.h
+++ b/drivers/net/wireless/ath/ath11k/trace.h
@@ -14,12 +14,24 @@
 #if !defined(CONFIG_ATH11K_TRACING)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {} \
+static inline bool trace_##name##_enabled(void) \
+{						\
+	return false;				\
+}
+
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
 static inline void trace_ ## name(proto) {}
 #endif /* !CONFIG_ATH11K_TRACING || __CHECKER__ */
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ath11k
 
+#define ATH11K_MSG_MAX 400
+
 TRACE_EVENT(ath11k_htt_pktlog,
 	    TP_PROTO(struct ath11k *ar, const void *buf, u16 buf_len,
 		     u32 pktlog_checksum),
@@ -105,6 +117,166 @@ TRACE_EVENT(ath11k_htt_rxdesc,
 	 )
 );
 
+DECLARE_EVENT_CLASS(ath11k_log_event,
+		    TP_PROTO(struct ath11k_base *ab, struct va_format *vaf),
+	TP_ARGS(ab, vaf),
+	TP_STRUCT__entry(
+		__string(device, dev_name(ab->dev))
+		__string(driver, dev_driver_string(ab->dev))
+		__dynamic_array(char, msg, ATH11K_MSG_MAX)
+	),
+	TP_fast_assign(
+		__assign_str(device, dev_name(ab->dev));
+		__assign_str(driver, dev_driver_string(ab->dev));
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH11K_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= ATH11K_MSG_MAX);
+	),
+	TP_printk(
+		"%s %s %s",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(msg)
+	)
+);
+
+DEFINE_EVENT(ath11k_log_event, ath11k_log_err,
+	     TP_PROTO(struct ath11k_base *ab, struct va_format *vaf),
+	     TP_ARGS(ab, vaf)
+);
+
+DEFINE_EVENT(ath11k_log_event, ath11k_log_warn,
+	     TP_PROTO(struct ath11k_base *ab, struct va_format *vaf),
+	     TP_ARGS(ab, vaf)
+);
+
+DEFINE_EVENT(ath11k_log_event, ath11k_log_info,
+	     TP_PROTO(struct ath11k_base *ab, struct va_format *vaf),
+	     TP_ARGS(ab, vaf)
+);
+
+TRACE_EVENT(ath11k_wmi_cmd,
+	    TP_PROTO(struct ath11k_base *ab, int id, const void *buf, size_t buf_len),
+
+	TP_ARGS(ab, id, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ab->dev))
+		__string(driver, dev_driver_string(ab->dev))
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ab->dev));
+		__assign_str(driver, dev_driver_string(ab->dev));
+		__entry->id = id;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s %s id %d len %zu",
+		__get_str(driver),
+		__get_str(device),
+		__entry->id,
+		__entry->buf_len
+	 )
+);
+
+TRACE_EVENT(ath11k_wmi_event,
+	    TP_PROTO(struct ath11k_base *ab, int id, const void *buf, size_t buf_len),
+
+	TP_ARGS(ab, id, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ab->dev))
+		__string(driver, dev_driver_string(ab->dev))
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ab->dev));
+		__assign_str(driver, dev_driver_string(ab->dev));
+		__entry->id = id;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s %s id %d len %zu",
+		__get_str(driver),
+		__get_str(device),
+		__entry->id,
+		__entry->buf_len
+	)
+);
+
+TRACE_EVENT(ath11k_log_dbg,
+	    TP_PROTO(struct ath11k_base *ab, unsigned int level, struct va_format *vaf),
+
+	TP_ARGS(ab, level, vaf),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ab->dev))
+		__string(driver, dev_driver_string(ab->dev))
+		__field(unsigned int, level)
+		__dynamic_array(char, msg, ATH11K_MSG_MAX)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ab->dev));
+		__assign_str(driver, dev_driver_string(ab->dev));
+		__entry->level = level;
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH11K_MSG_MAX, vaf->fmt,
+				       *vaf->va) >= ATH11K_MSG_MAX);
+	),
+
+	TP_printk(
+		"%s %s %s",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(msg)
+	)
+);
+
+TRACE_EVENT(ath11k_log_dbg_dump,
+	    TP_PROTO(struct ath11k_base *ab, const char *msg, const char *prefix,
+		     const void *buf, size_t buf_len),
+
+	TP_ARGS(ab, msg, prefix, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ab->dev))
+		__string(driver, dev_driver_string(ab->dev))
+		__string(msg, msg)
+		__string(prefix, prefix)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ab->dev));
+		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(msg, msg);
+		__assign_str(prefix, prefix);
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s %s %s/%s\n",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(prefix),
+		__get_str(msg)
+	)
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6b29d1d5178e2..79f46b17ee7ad 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -249,6 +249,8 @@ static int ath11k_wmi_cmd_send_nowait(struct ath11k_pdev_wmi *wmi, struct sk_buf
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	cmd_hdr->cmd_id = cmd;
 
+	trace_ath11k_wmi_cmd(ab, cmd_id, skb->data, skb->len);
+
 	memset(skb_cb, 0, sizeof(*skb_cb));
 	ret = ath11k_htc_send(&ab->htc, wmi->eid, skb);
 
@@ -6998,6 +7000,8 @@ static void ath11k_wmi_tlv_op_rx(struct ath11k_base *ab, struct sk_buff *skb)
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = FIELD_GET(WMI_CMD_HDR_CMD_ID, (cmd_hdr->cmd_id));
 
+	trace_ath11k_wmi_event(ab, id, skb->data, skb->len);
+
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		goto out;
 
-- 
2.53.0



