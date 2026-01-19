Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287DE32F766
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768809879; cv=none; b=B2w4R1w5uwFsbv/69Bw0+nL4nfVlFPq5XNzlYOfX77PF4RCN+tqgV14MTwN4adNuIYVe+t+cCEC441Nnh24MOOL0k6xjXNA1SeJDiw1ZMKyqXRLbHieKyZopiTKFHRKvuXq2YH8Ct3bnDELXWzndCe4y6/tZxsO4lQYcpWseIPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768809879; c=relaxed/simple;
	bh=fSk12Kv8vzWHPNwrVW04X+ndtNeLwKcienPDea2JogA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=tuYHKZ0arJOd4tUxFw9Qn4gw66Z6eeRn5FJAIeOeoa43U+P+rr1s81rJYAK6318VWEuszdNBEYI4ka+X9zy0g44aCR/pvIVGswjhmV8/gLmWSWFIxjmxniQ0xDwQOZK2dJXHBuZt3AwJw9brAYkSj05tELJayOcuaujldw0FusE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHZjTbWh; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHZjTbWh"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-653781de668so5802153a12.2
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 00:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768809876; x=1769414676; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fSk12Kv8vzWHPNwrVW04X+ndtNeLwKcienPDea2JogA=;
        b=RHZjTbWhWo2gZvxhkXMAreyIwsg8agW1c57CHs5K+l8hZVIpniGsrUQsFxj4qMlgdk
         WhdsPcDkVDJArknIilFpe9Z1t1Am8Axfubeqtnyj2yIeiLL6w6hyQYnJF9fhA4JQMKzG
         fKHvEGs+JzkmfZtoLfRRxl9htiWqw3YBENd3NLZiWM6c33w4UEAcBXkHCrqSoevTE/oY
         KByhpq2DCn96kRUFaiYOt4IHOLNWNV/9SjX9RLZvvujZnklI9MWQhQIJiagvUnd8jeza
         nz1NbLK3bvV0ouKqjg0PN8uyqwnmuGjqr1txDkdmbudrVCjzHALy+o2GjkQy71lhmMSU
         bK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768809876; x=1769414676;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fSk12Kv8vzWHPNwrVW04X+ndtNeLwKcienPDea2JogA=;
        b=I09HxeKPGlzQu3P8BlkVTyVUoV/mzk+U3k2D/EsNu5leSG1dsFeIMZAQZUKyNzJP5H
         7r5B5Gbv4MkZsiwp3/SlVH7nexT/ZapqHQeBcV5Us0ju+vzEz2Ai+/O+CpdISFyVixwF
         BbsDvhPyuuVQY/oxALJ//QVq8egIRtjnDbVWdJ/Upy1CXwbzEnmigL+2PC79eEH8g1YS
         7syGkdUzKtEVNlpPs78tQoh3WeEhO2fjbd9knjsI00SEWqxk8aDzB3yvmxaeFGZCFn9o
         r2YVMhU9iIRi5zTNYfUarBpCjLLtkzyrX7q7GfrL1A2/mlZwemJmYoN39wLPe8dipWZK
         PfvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjzlc4UGKVK2dd/5vsfGTcHagbTwXaYkrj0u8W1EkXP6I8wz+wQK2Cq0/kMUpioFjEpQFf84Dx@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5tsNwo7D4j/3eZCMedSN8fLNttjXZbOAMy+rUgrXg7cqw1hHh
	VFFuZ7vXQA7Zwu2YtMozJvgI3aVmkSeiLH95PwqA6123+E28ypDt76AH6nlc3jjxMF4kdK/I9J4
	KcFgfwBR8NJlzLG9RFTu7UtkEYpV5Sv0=
X-Gm-Gg: AY/fxX5yVZDJ8Ic1iiRVDbunH0NCJ2NcYNd1Q6sadzvxHzMZXHw3mpr8XCQKzrhPwcN
	R1rYLcKXW3axsGVDTLHu1PiaaTa/sXrx5xwOkYcDBcxiX6hE0+BGvQvjUym7yy9SjHqxqh6U5RG
	pgUl4qHeRQUbHCJBO9liNNrEDD+2F69n7JajYIedemlnqw45CvrTINC4hPDhSy8J+w9Z8ETERV+
	lJ/lSuxEWVu/eFvG05Hi9/QlJW0uJ1TZlxuVYcIHsxkRy0NMpo/sbHTQAPfe5z+U3EBJZQdbEkn
	qjIfQQuCI/JwDa0L8kY6tMKXqL0wPIvFKHHYmQ==
X-Received: by 2002:a17:907:6d08:b0:b87:1a92:b621 with SMTP id
 a640c23a62f3a-b879324e841mr878599966b.64.1768809876386; Mon, 19 Jan 2026
 00:04:36 -0800 (PST)
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Jan 2026 03:04:35 -0500
Received: from 860443694158 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 19 Jan 2026 03:04:35 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: zynai.founder@gmail.com
Date: Mon, 19 Jan 2026 03:04:35 -0500
X-Gm-Features: AZwV_QjOh7H8oNxE7nJj4oXOSyEyHo-o-wDGfblLl6I25ugW0u8RNniD7otOyKE
Message-ID: <CAEnpc1ZU=HtgrpTYFFE-PXgFy58C3eLQ4m7akAz=QJq6xfj6rw@mail.gmail.com>
Subject: Dentist Time Savers: Is AI Your Secret Weapon?
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, 
	patches@lists.linux.dev, info@morenofamilydentistry.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Moreno Family Dentistry Team,

As a dentist's office, you're likely no stranger to juggling
appointment scheduling, patient communication, and administrative
tasks. But let's face it =E2=80=93 with so much on your plate, how can you
free up more time for what matters most: patient care?

ZynAI helps businesses like yours save 5-10 hours per week by
automating repetitive workflows. With our AI-powered solutions, you'll
never have to worry about manual lead handling or tedious reporting
again.

Would it be worth a quick conversation to explore how ZynAI can
streamline your operations and boost productivity? I'm here to help
you discover the possibilities.

-ZynAI
