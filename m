Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AAE1F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793407; cv=none; b=Khz1av3nKG0GPGvT+PqD1YkaUJKKtK+pLFDrjzpxuYSf3y03Flcr+qrcKehUEl275EvXgDVUXDFXZdMGt8ubqwpJLl6MiMjMlWN8fGAH66Am6fDJ2wYOSUfkC0j5xr3zrTo7vbTCNHod9344Ee8qoq7Vgg7jlwRrphcqK+xAoCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793407; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5t4ZoDPHx+WSp3UW9OcakWv8FEk4ExGRPPKKeux+TA+crIjp4sJi82sY/Rvbi2hnSroRo0HNJQliqYgV4OmhTh1MR7Zj2jO3c6DOKztY+pyoI/DJeNHVgRWps0Phm9j/Xscy9OymxjzIhteAf+nbItXWReJSuhy+G1jyksO27g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BfBYcYeu; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BfBYcYeu"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212606e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793404; x=1730398204; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=BfBYcYeuDUmLyWd8OwhvNuy0VLXhMduvtnat8wp+m/XGAn71XpXB2mVtY9bPc2eOmk
         0N0R+rCp1u0aVGM/am+NXWEvYhADiQ+JqFJsJnmK63JjuC/iFR9hjPiru7mdAQk1i97I
         vkIRhecZxKj/FndfhiuSRo/L7+sKNX6aZejEF8LVD8SLEB1+XrFmt4Z+DA89hKuaxQb+
         1EoETBqaHOUFSrYLOjdcgYgF3Oi5x9Dqy2pfg8JCsR5kAPJnJtQiWcwP9sqcoJIk4qMQ
         +/xm3gV0t0/Ppw7wgUAmzCvEEYom6069iFvtQ73paGdtb5Bo+FZzns3fupfX47ARK+fS
         Jwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793404; x=1730398204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=gEqatGylau1v56X/jQPp/JQvwMtEy9yH6NG951bewwoi7gkdVMgiZWeaZpl1kaLruK
         1LPIBtkYRSALltpQJIVVgzv5vrfEd1H1xrh5BjcaRLC0K5+NXJMVPCXheMLwWrvT/Szc
         fFFZnFW3LqwYAJHw3y5lMHxJblmhqQIS7yCGgONNBYz0PyD3K85HdXiRFgSwwWBz4dvZ
         wbnUBvw11XtocEywWh5GxsSPy/07Ysp0+XgkyAHXcmaUOt/VnA3BJ6PdW/lrgIIcokJ6
         uC58y3O9wPx86vYK6vunMEHTlRGT3iyOAd0c98jaLfE1vTdB0zrABn1KG126pjN5/VMD
         k+2A==
X-Gm-Message-State: AOJu0YyHbPXZp5klGFOV2c2jPIqjsr+OIUGDDyCVrD48UKNJlyhHZOQY
	fMvG3Ewe5tbHkYz9tmeqwwnK9KViSpTMHK+/zB4xj/k1jEHRbBjYSz84FGgK
X-Google-Smtp-Source: AGHT+IFZA5AsQg7zlReeYTvZ6N5GfzqquY9za9ANvSJmcK1ByWSMPQBytVjczXL4HwCCP4vj+zHIkg==
X-Received: by 2002:a05:6512:3d8b:b0:539:f2f6:c6fe with SMTP id 2adb3069b0e04-53b1a308234mr4485740e87.16.1729793403974;
        Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243ede2sm1433144e87.269.2024.10.24.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:01 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4885-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
